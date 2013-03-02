//
//  hdStudent.m
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <sys/utsname.h>

#import "hdStudent.h"
#import "hdDataStore.h"
#import "hdHTTPWrapper.h"
#import "hdJsonWrapper.h"
#import "hdApiWrapper.h"

@implementation hdStudent

static hdStudent *sharedStudent;

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
		sharedStudent = [[hdStudent alloc] init];
	}
}

+ (hdStudent *)sharedStudent {
	return sharedStudent;
}

- (id)init {
	self = [super init];
	_store = [hdDataStore sharedStore];
	return self;
}

- (void)loginNewUser:(int)sid
						password:(int)pass
						callback:(void (^) (BOOL, NSString *, NSString *))callback
		progressCallback:(void (^) (float, NSString *))progressCallback {
	progressCallback(0.0, @"Authenticating…");
	[hdApiWrapper checkLogin:sid pass:pass callback:^(BOOL success, NSString *errorMsg, NSString *devError) {
		progressCallback(0.1, @"Transferring ones and zeroes…");
		if (!success) {
			callback(NO, errorMsg, [self createDetailedDevErrorReport:devError errorMsg:errorMsg apiMethod:@"userAuth" sid:sid]);
		} else {
			[hdApiWrapper indexerWithUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg, NSString *devError) {
				progressCallback(0.6, @"Downloading timetable…");
				[NSThread sleepForTimeInterval:1];
				if (!success) {
					callback(NO, errorMsg, [self createDetailedDevErrorReport:devError errorMsg:errorMsg apiMethod:@"indexer" sid:sid]);
				} else {
					[hdApiWrapper downloadTimetableForUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg, NSString *devError) {
						progressCallback(0.85, @"Downloading homework…");
						[NSThread sleepForTimeInterval:1];
						if (!success) {
							callback(NO, errorMsg, [self createDetailedDevErrorReport:devError errorMsg:errorMsg apiMethod:@"genClassList" sid:sid]);
						} else {
							// errorMsg contains response when there was no error!
							timetableJson = errorMsg;
							[hdApiWrapper downloadHomeworkForUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg, NSString *devError) {
								progressCallback(1.0, @"Finishing…");
								[NSThread sleepForTimeInterval:1];
								if (!success) {
									callback(NO, errorMsg, [self createDetailedDevErrorReport:devError errorMsg:errorMsg apiMethod:@"stringdown" sid:sid]);
								} else {
									_store.userLoggedIn = YES;
									_store.userId = sid;
									_store.timetableJson = timetableJson;
									_store.pass = pass;
									_store.homeworkJson = errorMsg;
									[_store synchronize];
									[self performSelector:@selector(callCallback:) withObject:callback afterDelay:0.1];
								}
							}];
						}
					}];
				}
			}];
		}
	}];
}

- (void)callCallback:(void (^) (BOOL, NSString *, NSString *))callback {
	callback(YES, nil, nil);
}

- (NSString *)createDetailedDevErrorReport:(NSString *)report errorMsg:(NSString *)errorMsg apiMethod:(NSString *)apiMethod sid:(int)sid {
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	f.timeStyle = NSDateFormatterFullStyle;
	f.dateStyle = NSDateFormatterFullStyle;
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_NZ"];
	return [NSString stringWithFormat:@"Put any extra details here:\n\n\n\n\n--- BEGIN ERROR REPORT ---\n\nERROR MESSAGE:\n  %@\n\nAPPLICATION:\n  hDubNative (iOS)\n  Version 2.0\n\nHTTP:\n  %@\n  apiMethod: %@\n  userId: %i\n\nLOCAL STORAGE:\n  userLoggedIn: %d\n\nSYSTEM INFO:\n  systemVersion: %@\n  device: %@\n  time: %@\n\n--- END OF ERROR REPORT ---",
					errorMsg,
					
					report,
					
					apiMethod,
					
					sid,
					[hdDataStore sharedStore].userLoggedIn,
					
					[UIDevice currentDevice].systemVersion,
					[self deviceName],
					[f stringFromDate:[NSDate date]]];
}

- (NSString *)deviceName {
	struct utsname systemInfo;
	uname(&systemInfo);
	return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end
