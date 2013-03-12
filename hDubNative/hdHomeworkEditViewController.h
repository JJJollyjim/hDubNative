//
//  hdHomeworkEditViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 9/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdHomeworkTask.h"
#import "hdTimetableParser.h"

@interface hdHomeworkEditViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic) hdHomeworkTask *homeworkTask;
@property (nonatomic) id previousViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
