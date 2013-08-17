//
//  hdHomeworkDataStore.m
//  hDubNative
//
//  Created by printfn on 21/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkDataStore.h"
#import "hdTimetableParser.h"
#import "hdJsonWrapper.h"
#import "hdDateUtils.h"

/*
 homeworkRootDictionary (from server):
 {
   "2013-03-21":{
     "5":[
       {
         "hwid":"abcddfgr",
         "name":"ADD REFERENCES TO ESSAY",
         "details":"DETAILED! ADDED WITH NEW API"
       }
     ]
   },
   "2013-01-30":{
     "1":[
       {
         "hwid":"26c32b40-33c0-dd1f-a97f-d25bc6722cd6",
         "name":"Form Time",
         "details":""
       }
     ]
   }
 }
 
 */

@implementation hdHomeworkDataStore

@synthesize tableView;

+ (hdHomeworkDataStore *)sharedStore {
	static hdHomeworkDataStore *sharedStore;
	if (!sharedStore) {
		sharedStore = [[hdHomeworkDataStore alloc] init];
	}
	return sharedStore;
}

#pragma mark - Initialization

- (id)init {
	if (self = [super init]) {
        sharedStore = [hdDataStore sharedStore];
        [self initializeHomeworkDataStore];
    }
	return self;
}

- (void)initializeHomeworkDataStore {
    NSString *homeworkJson = sharedStore.homeworkJson;
    NSDictionary *homeworkRootDictionary = [hdJsonWrapper getObj:homeworkJson];
    homeworkTasks = [NSMutableArray array];
    for (NSString *jsonDate in homeworkRootDictionary) {
        NSDictionary *periods = [homeworkRootDictionary objectForKey:jsonDate];
        for (NSString *period in periods) {
            NSArray *homeworkTasksDictionaries = [periods objectForKey:period];
            for (NSDictionary *homeworkTaskDictionary in homeworkTasksDictionaries) {
                hdHomeworkTask *homeworkTask = [[hdHomeworkTask alloc] init];
                homeworkTask.hwid = [homeworkTaskDictionary objectForKey:@"hwid"];
                homeworkTask.name = [homeworkTaskDictionary objectForKey:@"name"];
                homeworkTask.details = [homeworkTaskDictionary objectForKey:@"details"];
                homeworkTask.period = period.integerValue;
                [homeworkTask setDateWithJsonDateStr:jsonDate];
                [homeworkTasks addObject:homeworkTask];
            }
        }
    }
    [self sortHomeworkTasks];
}

- (void)sortHomeworkTasks {
    [homeworkTasks sortUsingSelector:@selector(compare:)];
}

- (void)storeHomeworkTasks {
    NSMutableDictionary *homeworkRootDictionary = [NSMutableDictionary dictionary];
    NSString *lastJsonDateString = @"";
    int lastPeriod = -1;
    for (hdHomeworkTask *homeworkTask in homeworkTasks) {
        if (![homeworkTask.date isEqualToString:lastJsonDateString]) {
            lastJsonDateString = homeworkTask.date;
            [homeworkRootDictionary setObject:[NSMutableDictionary dictionary] forKey:homeworkTask.date];
        }
        if (homeworkTask.period != lastPeriod) {
            lastPeriod = homeworkTask.period;
            [[homeworkRootDictionary objectForKey:homeworkTask.date] setObject:[NSMutableArray array]
                                                                        forKey:[NSString stringWithFormat:@"%i", homeworkTask.period]];
        }
        // Finally add the homework task
        [[[homeworkRootDictionary objectForKey:homeworkTask.date] objectForKey:[NSString stringWithFormat:@"%i", homeworkTask.period]] addObject:@{@"name": homeworkTask.name, @"details": homeworkTask.details, @"hwid": homeworkTask.hwid}];
    }
    NSString *json = [hdJsonWrapper getJson:homeworkRootDictionary];
    sharedStore.homeworkJson = json;
}

#pragma mark - UITableViewDelegate methods

- (int)numberOfSections {
    int sectionCount = 0;
    NSString *lastJsonDateString = @"";
    for (hdHomeworkTask *homeworkTask in homeworkTasks) {
        if (![homeworkTask.date isEqualToString:lastJsonDateString]) {
            lastJsonDateString = homeworkTask.date;
            ++sectionCount;
        }
    }
    return sectionCount;
}

- (int)numberOfRowsInSection:(int)section {
    int sectionCount = 0;
    NSString *lastJsonDateString = @"";
    BOOL foundSection = NO;
    int rowCount = 0;
    NSString *correctJsonDateString = @" ";
    for (hdHomeworkTask *homeworkTask in homeworkTasks) {
        if (![homeworkTask.date isEqualToString:lastJsonDateString]) {
            if (sectionCount == section) {
                foundSection = YES;
                correctJsonDateString = homeworkTask.date;
                rowCount++;
            }
            lastJsonDateString = homeworkTask.date;
            ++sectionCount;
        } else {
            if (foundSection && [homeworkTask.date isEqualToString:correctJsonDateString]) {
                rowCount++;
            }
        }
    }
    return rowCount;
}

- (NSString *)titleForHeaderInSection:(int)section {
    int currentSection = 0;
    NSString *lastJsonDateString = @"";
    for (hdHomeworkTask *homeworkTask in homeworkTasks) {
        if (![homeworkTask.date isEqualToString:lastJsonDateString]) {
            lastJsonDateString = homeworkTask.date;
            if (currentSection == section) {
                return [hdDateUtils formatDate:[hdDateUtils jsonDateToDate:homeworkTask.date]];
            }
            ++currentSection;
        }
    }
    
    return nil;
}

#pragma mark - Homework Task and Index Path Conversion Methods

- (hdHomeworkTask *)homeworkTaskAtIndexPath:(NSIndexPath *)indexPath {
    int section = indexPath.section;
    int row = indexPath.row;

    int currentSection = 0;
    int currentRow = 0;
    BOOL foundSection = NO;
    NSString *lastJsonDateString = @"";
    NSString *correctJsonDateString = @" ";
    for (hdHomeworkTask *homeworkTask in homeworkTasks) {
        if (![homeworkTask.date isEqualToString:lastJsonDateString]) {
            // Next section
            if (section == currentSection) {
                // Found correct section
                foundSection = YES;
                correctJsonDateString = homeworkTask.date;
                currentRow++;
            }
            lastJsonDateString = homeworkTask.date;
            ++currentSection;
        } else {
            if (foundSection && [homeworkTask.date isEqualToString:correctJsonDateString]) {
                currentRow++;
            }
        }
        if (foundSection && [homeworkTask.date isEqualToString:correctJsonDateString] && currentRow-1 == row)
            return homeworkTask;
    }
    return nil;
}

- (NSIndexPath *)indexPathOfHomeworkTaskWithId:(NSString *)hwid {
    int currentSection = -1;
    int currentRow = 0;
    NSString *lastJsonDateString = @"";
    BOOL foundHomeworkTask = NO;
    for (hdHomeworkTask *homeworkTask in homeworkTasks) {
        if (![homeworkTask.date isEqualToString:lastJsonDateString]) {
            // Next section
            lastJsonDateString = homeworkTask.date;
            ++currentSection;
            currentRow = 0;
        } else {
            currentRow++;
        }
        if ([homeworkTask.hwid isEqualToString:hwid]) {
            foundHomeworkTask = YES;
            break;
        }
    }
    if (foundHomeworkTask) {
        return [NSIndexPath indexPathForRow:currentRow inSection:currentSection];
    } else {
        return nil;
    }
}

- (NSIndexPath *)indexPathOfHomeworkTask:(hdHomeworkTask *)homeworkTask {
    return [self indexPathOfHomeworkTaskWithId:homeworkTask.hwid];
}

- (int)sectionCountOfHomeworkTasksWithDate:(NSString *)jsonDate {
    // jsonDate format: 2013-08-17
    BOOL foundDate = NO;
    int sectionCount = 0;
    for (hdHomeworkTask *homeworkTask in homeworkTasks) {
        if (!foundDate) {
            if ([homeworkTask.date isEqualToString:jsonDate]) {
                foundDate = YES;
                sectionCount++;
            }
        } else {
            if ([homeworkTask.date isEqualToString:jsonDate]) {
                sectionCount++;
            } else {
                break;
            }
        }
    }
    return sectionCount;
}

#pragma mark - Homework Task Deletion Methods

- (void)deleteHomeworkTaskWithId:(NSString *)hwid
                       indexPath:(NSIndexPath *)ip {
    int i = 0;
    BOOL foundCorrectHomeworkTask = NO;
    for (hdHomeworkTask *task in homeworkTasks) {
        if ([task.hwid isEqualToString:hwid]) {
            foundCorrectHomeworkTask = YES;
            break;
        }
        ++i;
    }
    if (!foundCorrectHomeworkTask) {
        [NSException raise:@"NoHomeworkTaskFound" format:@"Could not find homework task"];
    }
    int sectionCountBeforeDeletions = [self numberOfSections];
    [homeworkTasks removeObjectAtIndex:i];
    int sectionCountAfterDeletions = [self numberOfSections];
    [tableView beginUpdates];
    if (sectionCountBeforeDeletions == sectionCountAfterDeletions) {
        [tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationRight];
    } else {
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:ip.section] withRowAnimation:UITableViewRowAnimationRight];
    }
    [tableView endUpdates];
    [self storeHomeworkTasks];
}

- (void)deleteHomeworkTaskWithId:(NSString *)hwid {
    NSIndexPath *ip = [self indexPathOfHomeworkTaskWithId:hwid];
    [self deleteHomeworkTaskWithId:hwid indexPath:ip];
}

- (void)deleteHomeworkTaskAtIndexPath:(NSIndexPath *)ip {
    NSString *hwid = [self homeworkTaskAtIndexPath:ip].hwid;
    [self deleteHomeworkTaskWithId:hwid indexPath:ip];
}


#pragma mark - Homework Task Addition Methods

- (void)addHomeworkTask:(hdHomeworkTask *)homeworkTask {
    int sectionCountBeforeInsertion = [self numberOfSections];
    [homeworkTasks addObject:homeworkTask];
    [self sortHomeworkTasks];
    int sectionCountAfterInsertion = [self numberOfSections];
    NSIndexPath *indexPath = [self indexPathOfHomeworkTask:homeworkTask];
    [tableView beginUpdates];
    if (sectionCountBeforeInsertion == sectionCountAfterInsertion) {
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    } else {
        [tableView insertSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    [tableView endUpdates];
    [self storeHomeworkTasks];
}


- (void)updateHomeworkTaskWithId:(NSString *)hwid
             withNewHomeworkTask:(hdHomeworkTask *)task {
    [self deleteHomeworkTaskWithId:hwid];
    [self addHomeworkTask:task];
}

#pragma mark - Scroll to today

- (void)scrollToTodayAnimated:(BOOL)animated {
    if (homeworkTasks.count == 0)
        return;
    NSIndexPath *indexPathToScrollTo = nil;
    NSString *today = [hdDateUtils dateToJsonDate:[NSDate date]];
    for (int i = 0; i < homeworkTasks.count; ++i) {
        if ([((hdHomeworkTask *)[homeworkTasks objectAtIndex:i]).date compare:today] != NSOrderedAscending) {
            indexPathToScrollTo = [self indexPathOfHomeworkTask:[homeworkTasks objectAtIndex:i]];
            break;
        }
    }
    if (indexPathToScrollTo == nil) {
        indexPathToScrollTo = [self indexPathOfHomeworkTask:[homeworkTasks objectAtIndex:homeworkTasks.count - 1]];
    }
    [tableView scrollToRowAtIndexPath:indexPathToScrollTo atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

#pragma mark - Date formatting methods

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
