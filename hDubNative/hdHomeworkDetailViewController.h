//
//  hdHomeworkDetailViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 3/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdHomeworkTask.h"

@interface hdHomeworkDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *homeworkTitle;
@property (weak, nonatomic) IBOutlet UITableView *homeworkDataTableView;
@property (weak, nonatomic) IBOutlet UITextView *homeworkDetailTextView;
@property (nonatomic) hdHomeworkTask *homeworkTask;
@property (nonatomic) id homeworkViewController;

- (IBAction)done:(id)sender;
- (IBAction)editHomeworkTask:(id)sender;
- (IBAction)deleteHomeworkTask:(id)sender;

@end
