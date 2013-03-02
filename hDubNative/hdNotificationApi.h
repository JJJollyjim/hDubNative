//
//  hdNotificationApi.h
//  hDubNative
//
//  Created by printfn on 16/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdNotificationApi : NSObject <UIAlertViewDelegate> {
	NSString *url;
}

+ (void)startPolling;
+ (void)stopPolling;
+ (void)setOnLoginScreen:(BOOL)b;
+ (void)updateNow;

@end
