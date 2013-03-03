//
//  hdTimetableParser.m
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableParser.h"

@implementation hdTimetableParser

static NSDictionary *lastRootDictionary;
+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj {
	lastRootDictionary = obj;
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	f.dateFormat = @"yyyy-MM-dd";
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	NSString *dateStr = [f stringFromDate:date];
	NSDictionary *timetableDay = [obj valueForKey:dateStr];
	NSString *periodStr = [NSString stringWithFormat:@"%i", period + 1];
	return (NSString *)[[timetableDay valueForKey:periodStr] valueForKey:@"name"];
}

+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period {
	return [self getSubjectForDay:date period:period rootObj:lastRootDictionary];
}

+ (BOOL)schoolOnDay:(NSDate *)date rootObj:(NSDictionary *)obj {
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	f.dateFormat = @"yyyy-MM-dd";
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	NSString *dateStr = [f stringFromDate:[NSDate date]];
	NSDictionary *timetableDay = [obj valueForKey:dateStr];
	return timetableDay != nil;
}

@end
