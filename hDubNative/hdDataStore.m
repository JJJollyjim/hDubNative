//
//  hdDataStore.m
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdDataStore.h"
#import "hdJsonWrapper.h"

@implementation hdDataStore

+ (hdDataStore *)sharedStore {
	static hdDataStore *sharedStore;
	if (!sharedStore) {
		sharedStore = [[hdDataStore alloc] init];
	}
	return sharedStore;
}

- (id)init {
	self = [super init];
	
	defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults registerDefaults:@{
	 @"logged_in" : @NO,
	 @"sid" : @-1,
	 @"pass" : @0,
	 @"eid" : @0,
	 @"timetable" : @"",
	 @"homework" : @"",
     @"unsynced_events" : @"[]"}];
	
	return self;
}

- (void)synchronize {
	[defaults synchronize];
}

- (BOOL)userLoggedIn {
	return [defaults boolForKey:@"logged_in"];
}
- (void)setUserLoggedIn:(BOOL)userLoggedIn {
	return [defaults setBool:userLoggedIn forKey:@"logged_in"];
}

- (int)userId {
	return [defaults integerForKey:@"sid"];
}
- (void)setUserId:(int)sid {
	[defaults setInteger:sid forKey:@"sid"];
}

- (int)pass {
	return [defaults integerForKey:@"pass"];
}
- (void)setPass:(int)pass {
	[defaults setInteger:pass forKey:@"pass"];
}

- (int)higheid {
	return [defaults integerForKey:@"eid"];
}
- (void)setHigheid:(int)eid {
    if ([self higheid] != eid)
        NSLog(@"New version: %i", eid);
	[defaults setInteger:eid forKey:@"eid"];
}

- (NSString *)timetableJson {
	return [defaults stringForKey:@"timetable"];
}
- (void)setTimetableJson:(NSString *)json {
	[defaults setObject:json forKey:@"timetable"];
}

- (NSString *)homeworkJson {
	[defaults synchronize];
	return [defaults stringForKey:@"homework"];
}
- (void)setHomeworkJson:(NSString *)json {
	[defaults setObject:json forKey:@"homework"];
	[defaults synchronize];
}

- (void)setTimetableFormatString:(NSString *)s {
    [defaults setObject:s forKey:@"timetableFormatString"];
	[defaults synchronize];
}
- (NSString *)timetableFormatString {
	[defaults synchronize];
	return [defaults stringForKey:@"timetableFormatString"];
}
- (NSArray *)timetableFormat {
    return [hdJsonWrapper getObj:[self timetableFormatString]];
}
- (int)periodCount {
    NSArray *timetableFormat = [self timetableFormat];
    int count = 0;
    for (NSString *s in timetableFormat) {
        if ([s isEqualToString:@"period"])
            ++count;
    }
    return count;
}
- (NSString *)gapNameAfterPeriod:(int)period {
    NSArray *timetableFormat = [self timetableFormat];
    int count = 0;
    for (NSString *s in timetableFormat) {
        if ([s isEqualToString:@"period"]) {
            ++count;
            if (count == period) {
                // found the correct period
                int index = count - 1;
                int nextIndex = index + 1;
                NSString *nextIndexString;
                
                @try {
                    nextIndexString = [timetableFormat objectAtIndex:nextIndex];
                }
                @catch (NSException *exception) {
                    return nil;
                }
                if ([nextIndexString isEqualToString:@"period"])
                    return nil; // no gap name
                return nextIndexString;
            }
        }
    }
    return nil;
}
- (BOOL)isPeriodFollowedByGap:(int)period {
    NSString *nextGapName = [self gapNameAfterPeriod:period];
    return nextGapName == nil ? false : true;
}

- (NSString *)unsyncedEvents {
	[defaults synchronize];
	return [defaults stringForKey:@"unsynced_events"];
}
- (void)setUnsyncedEvents:(NSString *)e {
	[defaults setObject:e forKey:@"unsynced_events"];
	[defaults synchronize];
}

@end
