//
//  hdTimetableTableViewController.h
//  hDubNative
//
//  Created by printfn on 7/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "hdDataStore.h"
#import "hdTimetableDatePickerViewController.h"

@interface hdTimetableTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate> {
	hdDataStore *sharedStore;
	NSDictionary *timetableRootObject;
	NSDate *dateShown;
	NSDate *lastValidatedDate;
	
	// DateViewController
	UIPopoverController *datePickerPopover;
	hdTimetableDatePickerViewController *datePickerViewController;
	BOOL dateViewControllerCurrentlyShowing;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbi;

- (IBAction)updateTimetable:(id)sender;
- (void)updateTimetableWithAnimationLeft:(NSDate *)date;
- (void)updateTimetableWithAnimationRight:(NSDate *)date;
- (void)updateDateByDatePickerWithDate:(NSDate *)date;
- (IBAction)showDatePicker:(id)sender;
- (void)updateTimetableWithAnimation:(NSDate *)date;

@end
