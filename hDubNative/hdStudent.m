//
//  hdStudent.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <sys/utsname.h>

#import "hdApiWrapper.h"
#import "hdDataStore.h"
#import "hdGeneralUtilities.h"
#import "hdHTTPWrapper.h"
#import "hdHomeworkDataStore.h"
#import "hdJsonWrapper.h"
#import "hdStudent.h"

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

/*
 {
   data: {
     name: Jessica Fenton
     form: 11JG
     year: 12
   },
   high_eid: 56,
   homework: {
     01-01-2001: ...
   },
   timetable: {
     // Same format, but also with room+teacher
   },
   timetableFormat: [
     "period", "period", "Morning tea", "period", "period", "Lunch", "period", "period"
   ]
 }
 */

- (void)loginUser:(int)sid
         password:(int)pass
         callback:(void (^) (BOOL, NSString *, NSString *))callback {
	NSDate *dateBeforeRequest = [NSDate date];
	[hdApiWrapper loginWithSid:sid pass:pass callback:^(BOOL success, NSString *errorMsg, NSString *errorReport) {
		if (!success) {
			callback(NO, errorMsg, [self createDetailedDevErrorReport:errorReport errorMsg:errorMsg apiMethod:@"login" sid:sid startTime:dateBeforeRequest]);
		} else {
			// errorMsg = response when there was no error
			NSDictionary *jsonObj = [hdJsonWrapper getObj:errorMsg];
			_store.userLoggedIn = YES;
			_store.userId = sid;
			_store.pass = pass;
			_store.higheid = ((NSString *)[jsonObj objectForKey:@"high_eid"]).integerValue;
			_store.homeworkJson = [hdJsonWrapper getJson:[jsonObj objectForKey:@"homework"]];
            _store.timetableFormatString = [hdJsonWrapper getJson:[jsonObj objectForKey:@"timetableFormat"]];
			if ([_store.homeworkJson isEqualToString:@"[]"])
				_store.homeworkJson = @"{}";
			_store.timetableJson = [hdJsonWrapper getJson:[jsonObj objectForKey:@"timetable"]];
            [[hdHomeworkDataStore sharedStore] initializeHomeworkDataStore];
			[_store synchronize];
			callback(YES, nil, nil);
		}
	}];
}

- (NSString *)createDetailedDevErrorReport:(NSString *)report errorMsg:(NSString *)errorMsg apiMethod:(NSString *)apiMethod sid:(int)sid startTime:(NSDate *)startTime {
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	f.timeStyle = NSDateFormatterFullStyle;
	f.dateStyle = NSDateFormatterFullStyle;
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_NZ"];
	return [NSString stringWithFormat:@"Put any extra details here:\n\n\n\n\n--- BEGIN ERROR REPORT ---\n\nERROR MESSAGE:\n  %@\n\nAPPLICATION:\n  hDubNative (iOS)\n  Version %@\n\nHTTP:\n  %@\n  apiMethod: %@\n  userId: %i\n  duration: %f seconds\n\nLOCAL STORAGE:\n  userLoggedIn: %d\n\nSYSTEM INFO:\n  systemVersion: %@\n  device: %@\n  time: %@\n\n--- END OF ERROR REPORT ---",
            errorMsg,
			
            [hdGeneralUtilities currentVersion],
            
            report,
            
            apiMethod,
            
            sid,
            [[NSDate date] timeIntervalSinceDate:startTime],
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
