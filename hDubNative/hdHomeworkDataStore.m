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
				sharedStore = [hdDataStore sharedStore];
		[self initializeHomeworkData];
    }
	return self;
}

- (void)initializeHomeworkData {
	NSString *homeworkJson = [sharedStore homeworkJson];
	NSDictionary *homeworkRootDictionary = [hdJsonWrapper getObj:homeworkJson];
	higheid = [sharedStore higheid];
	homeworkTasksByDay = [[NSMutableArray alloc] initWithArray:[self createFlatHomeworkTable:homeworkRootDictionary]];
	dayIndexToHomeworkIndexMap = [[NSMutableDictionary alloc] init];
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
		[dayIndexToHomeworkIndexMap setObject:[NSNumber numberWithInt:homeworkTaskIndex] forKey:[NSNumber numberWithInt:dayIndex]];
		homeworkTaskIndex++;
	}
	[dayIndexToHomeworkCountOnDayMap setObject:[NSNumber numberWithInt:currentHomeworkCountForCurrentDayIndex]
																			forKey:[NSNumber numberWithInt:totalDayCount - 1]];
}

// true if sections got deleted
- (BOOL)reloadHomeworkDataAfterChangesToHomeworkTasksByDay {
	int priorTotalDayCount = totalDayCount;
	[jsonDateStringToDayIndexMap removeAllObjects];
	[dayIndexToHomeworkIndexMap removeAllObjects];
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
				[jsonDateStringToDayIndexMap setObject:jsonDateString forKey:[NSNumber numberWithInt:dayIndex]];
				dayIndex++;
				totalDayCount++;
				currentHomeworkCountForCurrentDayIndex = 0;
			}
		} else {
			currentHomeworkCountForCurrentDayIndex = 0;
		}
		currentHomeworkCountForCurrentDayIndex++;
		lastDate = task.date;
		[dayIndexToHomeworkIndexMap setObject:[NSNumber numberWithInt:homeworkTaskIndex] forKey:[NSNumber numberWithInt:dayIndex]];
		homeworkTaskIndex++;
	}
	if (homeworkTasksByDay.count != 0)
		totalDayCount++;
	[dayIndexToHomeworkCountOnDayMap setObject:[NSNumber numberWithInt:currentHomeworkCountForCurrentDayIndex]
																			forKey:[NSNumber numberWithInt:totalDayCount - 1]];
	[self exportHomeworkTasksByDayToDisk];
		if (priorTotalDayCount != totalDayCount)
		return YES;
	return NO;
}

- (void)setHomeworkTask:(hdHomeworkTask *)task
              tableView:(UITableView *)tableView
                section:(int)section
                    row:(int)row {
	for (hdHomeworkTask *homeworkTask in homeworkTasksByDay) {
		if ([homeworkTask.hwid isEqualToString:task.hwid]) {
			homeworkTask.name = task.name;
			homeworkTask.details = task.details;
			homeworkTask.date = task.date;
			homeworkTask.period = task.period;
			homeworkTask.subject = [hdTimetableParser getSubjectForDay:homeworkTask.date
                                                                period:homeworkTask.period - 1];
			homeworkTask.teacher = [hdTimetableParser getTeacherForDay:homeworkTask.date
                                                                period:homeworkTask.period - 1];
			homeworkTask.room = [hdTimetableParser getRoomForDay:homeworkTask.date
                                                          period:homeworkTask.period - 1];
			[self reloadHomeworkDataAfterChangesToHomeworkTasksByDay];
			[self sortHomeworkTasksByDay]; 
			[tableView reloadData];
			[self exportHomeworkTasksByDayToDisk];
			return;
		}
	}
	BOOL sameDayAsAnotherHomeworkTask = NO;
    for (hdHomeworkTask *homeworkTask in homeworkTasksByDay) {
        if (abs(homeworkTask.date.timeIntervalSinceReferenceDate - task.date.timeIntervalSinceReferenceDate) <= (86400/4)) {
			sameDayAsAnotherHomeworkTask = YES;
			break;
        }
    }
	[homeworkTasksByDay addObject:task];
	homeworkTasksByDay = [[NSMutableArray alloc] initWithArray:[homeworkTasksByDay sortedArrayUsingComparator:^NSComparisonResult(hdHomeworkTask *hw1, hdHomeworkTask *hw2) {
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
	}]];
	[self reloadHomeworkDataAfterChangesToHomeworkTasksByDay];
	[tableView reloadData];
	return;
	[tableView beginUpdates];
	if (!sameDayAsAnotherHomeworkTask) {
		[tableView insertSections:[NSIndexSet indexSetWithIndex:section]
						 withRowAnimation:UITableViewRowAnimationRight];
	} else {
		[tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]]
										 withRowAnimation:UITableViewRowAnimationRight];
	}
  return;
}

- (void)exportHomeworkTasksByDayToDisk {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	for (hdHomeworkTask *task in homeworkTasksByDay) {
		NSDateFormatter *f = [[NSDateFormatter alloc] init];
		f.dateFormat = @"yyyy-MM-dd";
		f.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
		f.timeZone = [NSTimeZone timeZoneWithName:@"NZST"];
		NSString *key = [f stringFromDate:task.date];
		if ([result objectForKey:key] == nil) {
			NSMutableDictionary *homeworkTask = [[NSMutableDictionary alloc] init];
			[homeworkTask setObject:task.name forKey:@"name"];
			[homeworkTask setObject:task.hwid forKey:@"hwid"];
			[homeworkTask setObject:task.details forKey:@"details"];
			NSMutableArray *homeworkTasks = [[NSMutableArray alloc] init];
			[homeworkTasks addObject:homeworkTask];
			NSMutableDictionary *periods = [[NSMutableDictionary alloc] init];
			[periods setObject:homeworkTasks forKey:[NSString stringWithFormat:@"%i", task.period]];
			[result setObject:periods forKey:key];
		} else {
			NSMutableDictionary *homeworkTask = [[NSMutableDictionary alloc] init];
			[homeworkTask setObject:task.name forKey:@"name"];
			[homeworkTask setObject:task.hwid forKey:@"hwid"];
			[homeworkTask setObject:task.details forKey:@"details"];
			NSMutableArray *homeworkTasks = [[NSMutableArray alloc] init];
			[homeworkTasks addObject:homeworkTask];
			NSMutableDictionary *periods = [[NSMutableDictionary alloc] init];
			[periods setObject:homeworkTasks forKey:[NSString stringWithFormat:@"%i", task.period]];
			NSMutableDictionary *previousPeriods = [result objectForKey:key];
			if ([previousPeriods objectForKey:[NSString stringWithFormat:@"%i", task.period]] == nil) {
				[previousPeriods setObject:homeworkTasks forKey:[NSString stringWithFormat:@"%i", task.period]];
			} else {
				NSMutableArray *previousHomeworkTasks = [previousPeriods objectForKey:
																								 [NSString stringWithFormat:@"%i", task.period]];
				[previousHomeworkTasks addObject:homeworkTask];
			}
		}
	}
	NSString *jsonResult = [hdJsonWrapper getJson:result];
	[hdDataStore sharedStore].homeworkJson = jsonResult;
}

- (void)sortHomeworkTasksByDay {
	homeworkTasksByDay = [NSMutableArray arrayWithArray:[homeworkTasksByDay sortedArrayUsingComparator:^NSComparisonResult(hdHomeworkTask *hw1, hdHomeworkTask *hw2) {
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
	}]];
}

- (NSArray *)createFlatHomeworkTable:(NSDictionary *)homeworkRootDictionary {
	totalHomeworkCount = 0;
	totalDayCount = 0;
	NSMutableArray *result = [[NSMutableArray alloc] init];
	jsonDateStringToDayIndexMap = [[NSMutableDictionary alloc] init];
	for (NSString *date in homeworkRootDictionary) {
		[jsonDateStringToDayIndexMap setObject:[NSNumber numberWithInt:totalDayCount] forKey:date];
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
				task.teacher = [hdTimetableParser getTeacherForDay:task.date period:task.period - 1];
				task.room = [hdTimetableParser getRoomForDay:task.date period:task.period - 1];
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

- (int)sectionToScrollToWhenTableViewBecomesVisible {
	int result = 0;
	int accumulatedSectionIndex = 0;
	NSDate *lastDate;
	for (hdHomeworkTask *task in homeworkTasksByDay) {
		if (task.date.timeIntervalSinceReferenceDate >= [[NSDate date] timeIntervalSinceReferenceDate]) {
			result = accumulatedSectionIndex;
			break;
		} else {
			if (abs(lastDate.timeIntervalSinceReferenceDate - [[task date] timeIntervalSinceReferenceDate]) > 86400/4) {
				accumulatedSectionIndex++;
			}
		}
		lastDate = task.date;
	}
	return result - 1;
}

NSDateFormatter *df = nil;
- (int)dayIndexForHomeworkTask:(hdHomeworkTask *)hw {
	if (!df) {
		df = [[NSDateFormatter alloc] init];
		df.dateFormat = @"yyyy-MM-dd";
		df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
		df.timeZone = [NSTimeZone timeZoneWithName:@"NZST"];
	}
	return ((NSNumber *)[jsonDateStringToDayIndexMap objectForKey:[df stringFromDate:hw.date]]).integerValue;
}

- (int)numberOfCellsInSection:(int)section {
	int result = [(NSNumber *)[dayIndexToHomeworkCountOnDayMap objectForKey:[NSNumber numberWithInt:section]] integerValue];
	return result;
}

- (hdHomeworkTask *)getHomeworkTaskForSection:(int)dayIndex id:(int)hwidx {
	int homeworkCount = [self numberOfCellsInSection:dayIndex];
	int errorCorrectionOffset = homeworkCount - 1;
	int dayOffset = [(NSNumber *)[dayIndexToHomeworkIndexMap objectForKey:[NSNumber numberWithInt:dayIndex]] integerValue];
	int flatHomeworkTableIndex = dayOffset + hwidx - errorCorrectionOffset;
	return [homeworkTasksByDay objectAtIndex:flatHomeworkTableIndex];
}

- (NSString *)getTableSectionHeadingForDayId:(int)dayIndex {
	int dayOffset = [(NSNumber *)[dayIndexToHomeworkIndexMap objectForKey:[NSNumber numberWithInt:dayIndex]] integerValue];
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

- (void)deleteHomeworkTaskWithHwid:(NSString *)hwid {
    hdHomeworkTask *taskToDelete = nil;
    for (hdHomeworkTask *task in homeworkTasksByDay) {
        if ([task.hwid isEqualToString:hwid]) {
            taskToDelete = task;
        }
    }
    [homeworkTasksByDay removeObject:taskToDelete];
    [self reloadHomeworkDataAfterChangesToHomeworkTasksByDay];
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