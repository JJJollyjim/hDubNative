//
//  hdHomeworkDataStore.m
//  hDubNative
//
//  Created by printfn on 21/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkDataStore.h"
#import "hdTimetableParser.h"

@implementation hdHomeworkDataStore

+ (hdHomeworkDataStore *)sharedStore {
	static hdHomeworkDataStore *sharedStore;
	if (!sharedStore) {
		sharedStore = [[hdHomeworkDataStore alloc] init];
	}
	return sharedStore;
}

- (id)init {
	if (self = [super init]) {
		NSLog(@"START");
		sharedStore = [hdDataStore sharedStore];
		[self initializeHomeworkData];
		NSLog(@"END");
	}
	return self;
}

- (void)initializeHomeworkData {
	NSString *homeworkJson = [sharedStore homeworkJson];
	NSDictionary *homeworkRootDictionary = [hdJsonWrapper getObj:homeworkJson];
	higheid = [sharedStore higheid];
	homeworkTasksByDay = [[NSMutableArray alloc] initWithArray:[self createFlatHomeworkTable:homeworkRootDictionary]];
	dayIndexToIndexMap = [[NSMutableDictionary alloc] init];
	dayIndexToHomeworkCountOnDayMap = [[NSMutableDictionary alloc] init];
	int dayIndex = 0;
	int homeworkTaskIndex = 0;
	int currentHomeworkCountForCurrentDayIndex = 0;
	NSDate *lastDate = nil;
	for (hdHomeworkTask *task in homeworkTasksByDay) {
		if (lastDate) {
			if (abs(lastDate.timeIntervalSinceReferenceDate - task.date.timeIntervalSinceReferenceDate) > (86400/4)) {
				[dayIndexToHomeworkCountOnDayMap setObject:[NSNumber numberWithInt:currentHomeworkCountForCurrentDayIndex]
																						forKey:[NSNumber numberWithInt:dayIndex]];
				dayIndex++;
				currentHomeworkCountForCurrentDayIndex = 0;
			}
		} else {
			currentHomeworkCountForCurrentDayIndex = 0;
		}
		currentHomeworkCountForCurrentDayIndex++;
		lastDate = task.date;
		[dayIndexToIndexMap setObject:[NSNumber numberWithInt:homeworkTaskIndex] forKey:[NSNumber numberWithInt:dayIndex]];
		homeworkTaskIndex++;
	}
	[dayIndexToHomeworkCountOnDayMap setObject:[NSNumber numberWithInt:currentHomeworkCountForCurrentDayIndex]
																			forKey:[NSNumber numberWithInt:totalDayCount - 1]];
}

// true if sections got deleted
- (BOOL)reloadHomeworkDataAfterChangesToHomeworkTasksByDay {
	int priorTotalDayCount = totalDayCount;
	[dayToIndexMap removeAllObjects];
	[dayIndexToIndexMap removeAllObjects];
	[dayIndexToHomeworkCountOnDayMap removeAllObjects];
	int dayIndex = 0;
	int homeworkTaskIndex = 0;
	int currentHomeworkCountForCurrentDayIndex = 0;
	NSDate *lastDate = nil;
	totalDayCount = 0;
	totalHomeworkCount = 0;
	for (hdHomeworkTask *task in homeworkTasksByDay) {
		if (task == nil)
			continue;
		totalHomeworkCount++;
		if (lastDate) {
			if (abs(lastDate.timeIntervalSinceReferenceDate - task.date.timeIntervalSinceReferenceDate) > (86400/4)) {
				[dayIndexToHomeworkCountOnDayMap setObject:[NSNumber numberWithInt:currentHomeworkCountForCurrentDayIndex]
																						forKey:[NSNumber numberWithInt:dayIndex]];
				NSDateFormatter *f = [[NSDateFormatter alloc] init];
				f.dateFormat = @"yyyy-MM-dd";
				f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
				f.timeZone = [NSTimeZone timeZoneWithName:@"NZST"];
				NSString *jsonDateString = [f stringFromDate:task.date];
				[dayToIndexMap setObject:jsonDateString forKey:[NSNumber numberWithInt:homeworkTaskIndex]];
				dayIndex++;
				totalDayCount++;
				currentHomeworkCountForCurrentDayIndex = 0;
			}
		} else {
			currentHomeworkCountForCurrentDayIndex = 0;
		}
		currentHomeworkCountForCurrentDayIndex++;
		lastDate = task.date;
		[dayIndexToIndexMap setObject:[NSNumber numberWithInt:homeworkTaskIndex] forKey:[NSNumber numberWithInt:dayIndex]];
		homeworkTaskIndex++;
	}
	if (homeworkTasksByDay.count != 0)
		totalDayCount++;
	[dayIndexToHomeworkCountOnDayMap setObject:[NSNumber numberWithInt:currentHomeworkCountForCurrentDayIndex]
																			forKey:[NSNumber numberWithInt:totalDayCount - 1]];
	if (priorTotalDayCount != totalDayCount)
		return true;
	return false;
}

- (NSArray *)createFlatHomeworkTable:(NSDictionary *)homeworkRootDictionary {
	totalHomeworkCount = 0;
	totalDayCount = 0;
	NSMutableArray *result = [[NSMutableArray alloc] init];
	dayToIndexMap = [[NSMutableDictionary alloc] init];
	for (NSString *date in homeworkRootDictionary) {
		[dayToIndexMap setObject:[NSNumber numberWithInt:totalDayCount] forKey:date];
		totalDayCount++;
		NSDictionary *periods = [homeworkRootDictionary objectForKey:date];
		for (NSString *period in periods) {
			NSArray *homeworkTasks = [periods objectForKey:period];
			for (NSDictionary *homeworkTask in homeworkTasks) {
				NSString *name = [homeworkTask objectForKey:@"name"];
				NSString *details = [homeworkTask objectForKey:@"details"];
				NSString *hwid = [homeworkTask objectForKey:@"hwid"];
				hdHomeworkTask *task = [[hdHomeworkTask alloc] init];
				task.name = name;
				task.details = details;
				task.hwid = hwid;
				task.period = period.integerValue;
				[task setDateWithJsonDateStr:date];
				task.subject = [hdTimetableParser getSubjectForDay:task.date period:task.period - 1];
				[result addObject:task];
				totalHomeworkCount++;
			}
		}
	}
	return [result sortedArrayUsingComparator:^NSComparisonResult(hdHomeworkTask *hw1, hdHomeworkTask *hw2) {
		NSComparisonResult res = [[hw1 date] compare:[hw2 date]];
		if (res == NSOrderedSame) {
			if (hw1.period < hw2.period) {
				return (NSComparisonResult)NSOrderedAscending;
			} else if (hw1.period > hw2.period) {
				return (NSComparisonResult)NSOrderedDescending;
			} else {
				res = [[hw1 name] compare:[hw2 name]];
				if (res == NSOrderedSame) {
					res = [[hw1 details] compare:[hw2 details]];
					if (res == NSOrderedSame) {
						res = [[hw1 hwid] compare:[hw2 hwid]];
					}
				}
			}
		}
		return res;
	}];
}

- (int)numberOfSectionsInTableView {
	return totalDayCount;
}

- (int)numberOfCellsInSection:(int)section {
	int result = [(NSNumber *)[dayIndexToHomeworkCountOnDayMap objectForKey:[NSNumber numberWithInt:section]] integerValue];
	return result;
}

- (hdHomeworkTask *)getHomeworkTaskForSection:(int)dayIndex id:(int)hwidx {
	int homeworkCount = [self numberOfCellsInSection:dayIndex];
	int errorCorrectionOffset = homeworkCount - 1;
	int dayOffset = [(NSNumber *)[dayIndexToIndexMap objectForKey:[NSNumber numberWithInt:dayIndex]] integerValue];
	int flatHomeworkTableIndex = dayOffset + hwidx - errorCorrectionOffset;
	return [homeworkTasksByDay objectAtIndex:flatHomeworkTableIndex];
}

- (NSString *)getTableSectionHeadingForDayId:(int)dayIndex {
	int dayOffset = [(NSNumber *)[dayIndexToIndexMap objectForKey:[NSNumber numberWithInt:dayIndex]] integerValue];
	hdHomeworkTask *firstHomeworkTaskAtDay = [homeworkTasksByDay objectAtIndex:dayOffset];
	NSDate *date = firstHomeworkTaskAtDay.date;
	return [hdHomeworkDataStore formatDate:date];
}

// true when a section also got deleted
- (BOOL)deleteCellAtDayIndex:(int)dayIndex id:(int)hwidx {
	hdHomeworkTask *hwtask = [self getHomeworkTaskForSection:dayIndex id:hwidx];
	[homeworkTasksByDay removeObject:hwtask];
	return [self reloadHomeworkDataAfterChangesToHomeworkTasksByDay];
}

- (NSArray *)sortHomeworkDictionaryByDates:(NSDictionary *)homeworkRootDictionary {
	NSArray *sortedDays = [self sortKeysInDictionary:homeworkRootDictionary];
	
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	f.dateFormat = @"yyyy-MM-dd";
	f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
	f.timeZone = [NSTimeZone timeZoneWithName:@"NZST"];
	
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for (NSString *key in sortedDays) {
		[result addObject:key];
	}
	return result;
}

- (NSArray *)sortKeysInDictionary:(NSDictionary *)homeworkRootDictionary {
	NSArray *sortedKeys = [[homeworkRootDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *date1str, NSString *date2str) {
		return [date1str compare:date2str];
	}];
	
	return sortedKeys;
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
