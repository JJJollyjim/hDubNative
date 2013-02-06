//
//  hdStudent.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdStudent.h"
#import "hdDataStore.h"
#import "hdHTTPWrapper.h"
#import "hdJsonWrapper.h"
#import "hdApiWrapper.h"

@implementation hdStudent

- (void)loginNewUser:(int)sid
						password:(int)pass
						callback:(void (^) (BOOL, NSString *))callback {
	if (/*!_store.userLoggedIn*/YES) {
		[hdApiWrapper checkLogin:sid pass:pass callback:^(BOOL success, NSString *errorMsg) {
			if (!success) {
				callback(NO, errorMsg);
			} else {
				[hdApiWrapper indexerWithUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg) {
					if (!success) {
						callback(NO, errorMsg);
					} else {
						[hdApiWrapper downloadTimetableForUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg) {
							if (!success) {
								callback(NO, errorMsg);
							} else {
								// errorMsg contains response when there was no error!
								_timetable = errorMsg;
								[hdApiWrapper downloadHomeworkForUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg) {
									if (!success) {
										callback(NO, errorMsg);
									} else {
										_homework = errorMsg;
										NSLog(@"SUCCESS!!!");
										_store.userLoggedIn = YES;
										_store.userId = sid;
										_store.pass = pass;
										_store.homeworkJson = _homework;
										_store.timetableJson = _timetable;
										callback(YES, nil);
									}
								}];
							}
						}];
					}
				}];
			}
		}];
	}
}

@end
