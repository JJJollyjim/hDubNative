//
//  hdDataStore.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdDataStore.h"

@implementation hdDataStore

- (id)init {
	self = [super init];
	
	defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults registerDefaults:@{
	 @"logged_in" : @NO,
	 @"sid" : @0,
	 @"pass" : @0,
	 @"eid" : @0,
	 @"timetable" : @"",
	 @"homework" : @""}];
	
	return self;
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
	[defaults setInteger:eid forKey:@"eid"];
}

- (NSString *)timetableJson {
	return [defaults stringForKey:@"timetable"];
}
- (void)setTimetableJson:(NSString *)json {
	[defaults setObject:json forKey:@"timetable"];
}

- (NSString *)homeworkJson {
	return [defaults stringForKey:@"homework"];
}
- (void)setHomeworkJson:(NSString *)json {
	[defaults setObject:json forKey:@"homework"];
}

@end
