//
//  hdTimetableTableViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 7/02/13.
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
	
	// DateViewController
	UIPopoverController *datePickerPopover;
	hdTimetableDatePickerViewController *datePickerViewController;
	UIBarButtonItem *bbi;
	BOOL dateViewControllerCurrentlyShowing;
}

- (IBAction)showDatePicker:(id)sender;
- (UIPopoverController *)getPopoverController;
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController;
- (IBAction)updateTimetable:(id)sender;

@end
