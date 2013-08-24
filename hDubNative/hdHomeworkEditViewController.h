//
//  hdHomeworkEditViewController.h
//  hDubNative
//
//  Created by printfn on 9/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdHomeworkTask.h"
#import "hdTimetableParser.h"
#import "hdHomeworkDataStore.h" 

@interface hdHomeworkEditViewController : UITableViewController <UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate> {
	UITextField *nameTextField;
	UITextView *detailsTextView;
	UIPopoverController *popover;
}

@property (nonatomic) hdHomeworkTask *homeworkTask;
@property (nonatomic) id previousViewController;
@property (nonatomic) hdHomeworkDataStore *homeworkDataStore;
@property (nonatomic) BOOL newHomeworkTask;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;
- (void)datePickerViewControllerSetDate:(NSDate *)date;

@end
