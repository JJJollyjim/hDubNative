//
//  hdNotificationApi.m
//  hDubNative
//
//  Created by printfn on 16/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdNotificationApi.h"
#import "hdApiWrapper.h"
#import "hdDataStore.h"
#import "hdJsonWrapper.h"

@implementation hdNotificationApi

static hdNotificationApi *sharedInstance;
static NSTimer *timer;
static BOOL onLoginScreen;

+ (void)setOnLoginScreen:(BOOL)b {
	onLoginScreen = b;
}

+ (void)startPolling {
	sharedInstance = [[hdNotificationApi alloc] init];
	timer = [NSTimer scheduledTimerWithTimeInterval:5
																					 target:sharedInstance
																				 selector:@selector(sendNotification:)
																				 userInfo:nil
																					repeats:YES];
	[sharedInstance sendNotification:timer];
}

+ (void)stopPolling {
	[timer invalidate];
}

+ (void)updateNow {
	[sharedInstance sendNotification:timer];
}

- (void)sendNotification:(NSTimer *)theTimer {
	/*[hdApiWrapper indexerWithUser:9079 pass:9391 callback:^(BOOL success, NSString *s1, NSString *s2) {
		NSLog(@"%@", s1);
	}];*/
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[hdApiWrapper getMessage:[hdDataStore sharedStore].userId pass:[hdDataStore sharedStore].pass fromLoginScreen:![hdDataStore sharedStore].userLoggedIn callback:^(BOOL success, NSString *response, NSString *detailedError) {
		if (success) {
			NSDictionary *dict = [hdJsonWrapper getObj:response];
			if (dict == nil) {
				return;
			}
			if ([dict objectForKey:@"error"] != nil) {
				return;
			}
			if ([dict objectForKey:@"message"] == nil) {
				return;
			}
			/*
			 
			 dict:
			   message: Alert message
			   message_title: Alert Title
			   link: URL
			   link_title: Link title
			 
			 */
			[notificationCenter postNotificationName:@"hdShowMessage" object:self userInfo:dict];
			if (!onLoginScreen) {
				NSString *title = [dict objectForKey:@"message_title"];
				NSString *message = [dict objectForKey:@"message"];
				BOOL containsLink = [dict objectForKey:@"link"] != nil && [dict objectForKey:@"link"];
				if (!containsLink) {
					UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
					[av show];
				} else {
					NSString *linkTitle = [dict objectForKey:@"link_title"];
					UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:linkTitle, nil];
					url = [dict objectForKey:@"link"];
					[av show];
				}
			}
		}
	}];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
	}
}

@end