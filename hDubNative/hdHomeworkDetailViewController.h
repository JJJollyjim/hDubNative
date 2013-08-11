//
//  hdHomeworkDetailViewController.h
//  hDubNative
//
//  Created by printfn on 3/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdHomeworkTask.h"
#import "hdHomeworkDataStore.h"

@interface hdHomeworkDetailViewController : UIViewController
<UITableViewDataSource,
UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *homeworkTitle;
@property (weak, nonatomic) IBOutlet UITableView *homeworkDataTableView;
@property (weak, nonatomic) IBOutlet UITextView *homeworkDetailTextView;
@property (weak, nonatomic) IBOutlet UILabel *noDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) hdHomeworkTask *homeworkTask;
@property (nonatomic) int section;
@property (nonatomic) int row;
@property (nonatomic) id homeworkViewController;
@property (nonatomic) hdHomeworkDataStore *homeworkDataStore;
@property (nonatomic) UIActionSheet *actionSheet;
@property (nonatomic) BOOL updated;

- (IBAction)done:(id)sender;
- (IBAction)deleteHomeworkTask:(id)sender;
- (void)updateHomeworkTask:(hdHomeworkTask *)homeworkTask;

@end
