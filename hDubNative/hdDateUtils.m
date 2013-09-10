//
//  hdDateUtils.m
//  hDubNative
//
//  Created by Jamie McClymont on 9/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdDataStore.h"
#import "hdDateUtils.h"
#import "hdTimetableParser.h"

@implementation hdDateUtils

BOOL initialized = NO;
NSCalendar *calendar;
NSRange weekdayRange;
static NSDateFormatter *f;

+ (void)initializeStuff {
	if (!initialized) {
		calendar = [NSCalendar currentCalendar];
		weekdayRange = [calendar maximumRangeOfUnit:NSWeekdayCalendarUnit];
        f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"yyyy-MM-dd";
        f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-NZ"];
		initialized = YES;
	}
}

+ (BOOL)isWeekend:(NSDate *)date {
    [hdDateUtils initializeStuff];
	NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
	NSUInteger weekdayOfDate = [components weekday];
	
	if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length) {
		return YES;
	}
	return NO;
}

+ (int)calculateFirstOfConsecutivePeriodsOfPeriod:(int)period date:(NSDate *)date {
    int firstPeriod = 1;
    for (NSString *timetableFormatItem in [hdDataStore sharedStore].timetableFormat) {
        if (firstPeriod >= period) {
            return period;
        }
        if ([[hdTimetableParser getSubjectForDay:date period:period]
             isEqualToString:[hdTimetableParser getSubjectForDay:date period:firstPeriod]]) {
            return firstPeriod;
        }
        if ([timetableFormatItem isEqualToString:@"period"]) {
            firstPeriod++;
        }
    }
    return period;
}

+ (NSString *)dateToJsonDate:(NSDate *)date {
    return [f stringFromDate:date];
}

+ (NSDate *)jsonDateToDate:(NSString *)dateString {
    return [[f dateFromString:dateString] dateByAddingTimeInterval:43200];
}

// Any date that the user selects/enters for a timetable view will run through this function, which will return the best day for which a timetable exists

+ (NSDate *)correctDate:(NSDate *)date {
	return [self correctDate:date inverted:NO];
}

+ (NSDate *)correctDateInverted:(NSDate *)date {
    return [self correctDate:date inverted:YES];
}

+ (NSDate *)correctDate:(NSDate *)date
               inverted:(BOOL)inverted {
    NSDate *prevDate = date;
	int iterations = 0;
	for (;;) {
		iterations++;
		if ([hdDateUtils isWeekend:date] || [hdTimetableParser getSubjectForDay:date period:1] == nil) {
			date = [date dateByAddingTimeInterval:inverted ? -86400 : 86400];
			if (iterations >= 366) {
				date = prevDate;
				iterations = 0;
				for (;;) {
					iterations++;
					if ([hdDateUtils isWeekend:date] || [hdTimetableParser getSubjectForDay:date period:1] == nil) {
						date = [date dateByAddingTimeInterval:inverted ? 86400 : -86400];
						if (iterations >= 366) {
							break;
						}
					} else {
						break;
					}
				}
				break;
			}
		} else {
			break;
		}
	}
	return date;
}

+ (NSString *)formatDate:(NSDate *)date {
	NSTimeInterval timeInterval =
	[[self dateAtMidnight:date] timeIntervalSinceReferenceDate]
	- [[self dateAtMidnight:[NSDate date]] timeIntervalSinceReferenceDate];
	int numOfDays = timeInterval / 86400;
	
	if (numOfDays == 0)
		return @"Today";
	
	if (numOfDays == 1)
		return @"Tomorrow";
	
	if (numOfDays == -1)
		return @"Yesterday";
	
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *componentsDateSpecified = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	NSDateComponents *componentsToday = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
	
	int month1 = componentsDateSpecified.month;
	int month2 = componentsToday.month;
	
	if (month1 == month2) {
		NSDateFormatter *f = [[NSDateFormatter alloc] init];
		[f setDateFormat:@"EEE d"];
		return [f stringFromDate:date];
	}
	
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	[f setDateFormat:@"EEE d MMM"];
	return [f stringFromDate:date];
}

+ (NSDate *)dateAtMidnight:(NSDate *)date {
	// Return a new date that has the same year,
	//  month and day components of the current date,
	//  but with the time set to 12:00 AM.
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
	return [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
}

@end
