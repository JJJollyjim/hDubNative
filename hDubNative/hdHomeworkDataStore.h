//
//  hdHomeworkDataStore.h
//  hDubNative
//
//  Created by printfn on 21/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hdDataStore.h"
#import "hdJsonWrapper.h"
#import "hdHomeworkTask.h"

@interface hdHomeworkDataStore : NSObject {
	hdDataStore *sharedStore;
	NSMutableArray *homeworkTasksByDay;
	NSMutableDictionary *jsonDateStringToDayIndexMap;
	NSMutableDictionary *dayIndexToHomeworkIndexMap;
	NSMutableDictionary *dayIndexToHomeworkCountOnDayMap;
	int higheid;
	int totalHomeworkCount;
	int totalDayCount;
}

- (int)numberOfSectionsInTableView;
- (int)numberOfCellsInSection:(int)section;
- (hdHomeworkTask *)getHomeworkTaskForSection:(int)dayIndex id:(int)hwidx;
- (NSString *)getTableSectionHeadingForDayId:(int)dayIndex;
- (BOOL)deleteCellAtDayIndex:(int)dayIndex id:(int)hwidx;
- (void)deleteHomeworkTaskWithHwid:(NSString *)hwid;
- (void)setHomeworkTask:(hdHomeworkTask *)task tableView:(UITableView *)tableView section:(int)section row:(int)row;
- (int)sectionToScrollToWhenTableViewBecomesVisible;

@end
