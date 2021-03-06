//
//  hdHomeworkDataStore.h
//  hDubNative
//
//  Created by Jamie McClymont on 21/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "hdDataStore.h"
#import "hdHomeworkTask.h"
#import "hdJsonWrapper.h"

@class hdHomeworkSyncManager;

@interface hdHomeworkDataStore : NSObject {
	hdDataStore *sharedStore;
    NSMutableArray *homeworkTasks; // Sorted array of hdHomeworkTasks
	int higheid;
    hdHomeworkSyncManager *syncManager;
}

#pragma mark - Properties

@property (nonatomic) UITableView *tableView;



#pragma mark - Initialization

+ (hdHomeworkDataStore *)sharedStore;
- (void)initializeHomeworkDataStore;
- (void)sortHomeworkTasks;
- (void)storeHomeworkTasks;



#pragma mark - UITableViewDelegate methods

- (int)numberOfSections;
- (int)numberOfRowsInSection:(int)section;
- (NSString *)titleForHeaderInSection:(int)section;


#pragma mark - Homework Task and Index Path Conversion Methods

- (NSIndexPath *)indexPathOfHomeworkTask:(hdHomeworkTask *)homeworkTask;
- (NSIndexPath *)indexPathOfHomeworkTaskWithId:(NSString *)hwid;
- (hdHomeworkTask *)homeworkTaskAtIndexPath:(NSIndexPath *)indexPath;
- (int)sectionCountOfHomeworkTasksWithDate:(NSString *)jsonDate;
- (NSArray *)homeworkTasksOnDay:(NSString *)jsonDate;


- (void)deleteHomeworkTaskWithId:(NSString *)hwid
                       indexPath:(NSIndexPath *)ip;
- (void)deleteHomeworkTaskWithId:(NSString *)hwid;
- (void)deleteHomeworkTaskAtIndexPath:(NSIndexPath *)ip;


#pragma mark - Homework Task Addition Methods

- (void)addHomeworkTask:(hdHomeworkTask *)homeworkTask;
- (void)updateHomeworkTaskWithId:(NSString *)hwid
             withNewHomeworkTask:(hdHomeworkTask *)task;

#pragma mark - Util Methods

- (void)scrollToTodayAnimated:(BOOL)animated;

@end
