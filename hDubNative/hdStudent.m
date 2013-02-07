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

static hdStudent *sharedStudent;

+ (void)initialize
{
	static BOOL initialized = NO;
	if(!initialized)
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
						callback:(void (^) (BOOL, NSString *))callback
		progressCallback:(void (^) (float, NSString *))progressCallback {
	progressCallback(0.0, @"Logging in…");
	[hdApiWrapper checkLogin:sid pass:pass callback:^(BOOL success, NSString *errorMsg) {
		progressCallback(0.1, @"Connecting to WGC…");
		if (!success) {
			callback(NO, errorMsg);
		} else {
			[hdApiWrapper indexerWithUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg) {
				progressCallback(0.6, @"Downloading timetable…");
				//[NSThread sleepForTimeInterval:1];
				if (!success) {
					callback(NO, errorMsg);
				} else {
					[hdApiWrapper downloadTimetableForUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg){
						progressCallback(0.85, @"Downloading homework…");
						[NSThread sleepForTimeInterval:1];
						if (!success) {
							callback(NO, errorMsg);
						} else {
							// errorMsg contains response when there was no error!
							_store.timetableJson = errorMsg;
							[hdApiWrapper downloadHomeworkForUser:sid pass:pass callback:^(BOOL success, NSString *errorMsg) {
								progressCallback(1.0, @"Finished…");
								[NSThread sleepForTimeInterval:1];
								if (!success) {
									callback(NO, errorMsg);
								} else {
									_store.homeworkJson = errorMsg;
									_store.userLoggedIn = YES;
									_store.userId = sid;
									_store.pass = pass;
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

@end
