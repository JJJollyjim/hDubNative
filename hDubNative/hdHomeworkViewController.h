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
@property (nonatomic) hdHomeworkDataStore *homeworkDataStore;
@property (nonatomic) hdHomeworkSyncManager *syncManager;

- (IBAction)goToToday:(id)sender;

@end
