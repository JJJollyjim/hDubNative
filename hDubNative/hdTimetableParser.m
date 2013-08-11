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
static NSDateFormatter *f;

+ (void)initializeDateFormatter {
	f = [[NSDateFormatter alloc] init];
	f.dateFormat = @"yyyy-MM-dd";
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
}

+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj {
    if (period == 0)
        return @"All Day";
	lastRootDictionary = obj;
	NSString *dateStr = [f stringFromDate:date];
	NSDictionary *timetableDay = [obj valueForKey:dateStr];
	NSString *periodStr = [NSString stringWithFormat:@"%i", period];
	return (NSString *)[[timetableDay valueForKey:periodStr] valueForKey:@"name"];
}

+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period {
	return [self getSubjectForDay:date period:period rootObj:lastRootDictionary];
}

+ (NSString *)getRoomForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj {
	lastRootDictionary = obj;
	NSString *dateStr = [f stringFromDate:date];
	NSDictionary *timetableDay = [obj valueForKey:dateStr];
	NSString *periodStr = [NSString stringWithFormat:@"%i", period];
	return (NSString *)[[timetableDay valueForKey:periodStr] valueForKey:@"room"];
}

+ (NSString *)getRoomForDay:(NSDate *)date period:(int)period {
	return [self getRoomForDay:date period:period rootObj:lastRootDictionary];
}

+ (NSString *)getTeacherForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj {
	lastRootDictionary = obj;
	NSString *dateStr = [f stringFromDate:date];
	NSDictionary *timetableDay = [obj valueForKey:dateStr];
	NSString *periodStr = [NSString stringWithFormat:@"%i", period];
	return (NSString *)[[timetableDay valueForKey:periodStr] valueForKey:@"teacher"];
}

+ (NSString *)getTeacherForDay:(NSDate *)date period:(int)period {
	return [self getTeacherForDay:date period:period rootObj:lastRootDictionary];
}

+ (BOOL)schoolOnDay:(NSDate *)date rootObj:(NSDictionary *)obj {
	NSString *dateStr = [f stringFromDate:[NSDate date]];
	NSDictionary *timetableDay = [obj valueForKey:dateStr];
	return timetableDay != nil;
}

@end
