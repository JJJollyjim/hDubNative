//
//  hdTimetableTableDetailViewController.h
//  hDubNative
//
//  Created by printfn on 7/21/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdHomeworkDataStore.h"

@interface hdTimetableTableDetailViewController : UITableViewController {
    hdHomeworkDataStore *homeworkDataStore;
    hdDataStore *sharedStore;
    NSArray *homeworkTasksOnDay;
}

@property (nonatomic) id timetableTableViewController;

@property (nonatomic) NSString *date;
@property (nonatomic) int period;

- (void)reloadData;

@end
