//
//  hdDataStore.m
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdDataStore.h"

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
	 @"pass" : @-0,
	 @"eid" : @0,
	 @"timetable" : @"",
	 @"homework" : @""}];
	
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

- (NSString *)name {
	return [defaults stringForKey:@"name"];
}
- (void)setName:(NSString *)name {
	[defaults setObject:name forKey:@"name"];
}
- (NSString *)form {
	return [defaults stringForKey:@"form"];
}
- (void)setForm:(NSString *)form {
	[defaults setObject:form forKey:@"form"];
}
- (int)year {
	return [defaults integerForKey:@"year"];
}
- (void)setYear:(int)year {
	[defaults setInteger:year forKey:@"year"];
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
	[defaults synchronize];
	return [defaults stringForKey:@"homework"];
}
- (void)setHomeworkJson:(NSString *)json {
	[defaults setObject:json forKey:@"homework"];
	[defaults synchronize];
}

@end
