//
//  hdDataStore.h
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdDataStore : NSObject {
	NSUserDefaults *defaults;
}

+ (hdDataStore *)sharedStore;

- (void)synchronize;

- (BOOL)userLoggedIn;
- (void)setUserLoggedIn:(BOOL)userLoggedIn;

- (int)userId;
- (void)setUserId:(int)sid;

- (int)pass;
- (void)setPass:(int)pass;

- (int)higheid;
- (void)setHigheid:(int)eid;

- (NSString *)timetableJson;
- (void)setTimetableJson:(NSString *)json;

- (NSString *)homeworkJson;
- (void)setHomeworkJson:(NSString *)json;

- (void)setTimetableFormatString:(NSString *)s;
- (NSString *)timetableFormatString;
- (NSArray *)timetableFormat;
- (int)periodCount;
- (NSString *)gapNameAfterPeriod:(int)period;
- (BOOL)isPeriodFollowedByGap:(int)period;

- (NSString *)unsyncedEvents;
- (void)setUnsyncedEvents:(NSString *)e;

@end
