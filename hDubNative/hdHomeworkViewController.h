//
//  hdHomeworkViewController.h
//  hDubNative
//
//  Created by printfn on 16/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdHomeworkDataStore.h"

@class hdHomeworkSyncManager;

@interface hdHomeworkViewController : UITableViewController

@property (nonatomic) NSString *homeworkJsonString;
@property (nonatomic) hdHomeworkDataStore *parser;
@property (nonatomic) hdHomeworkSyncManager *syncManager;

- (void)deleteHomeworkTaskWithSection:(int)section dayIndex:(int)dayIndex;
- (void)setHomeworkTask:(hdHomeworkTask *)homeworkTask inSection:(int)section row:(int)row;
- (IBAction)goToToday:(id)sender;

@end
