//
//  hdTimetableParser.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableParser.h"

@implementation hdTimetableParser

+ (NSString *)getSubjectForDay:(NSDate *)date period:(int)period rootObj:(NSDictionary *)obj {
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	f.dateFormat = @"yyyy-MM-dd";
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	NSString *dateStr = [f stringFromDate:[NSDate date]];
	return (NSString *)[[[obj valueForKey:dateStr] valueForKey:[NSString stringWithFormat:@"%i", period]] valueForKey:@"name"];
}

@end
