//
//  hdTimetableDatePickerViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 10/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableDatePickerViewController.h"
#import "hdTimetableTableViewController.h"

@implementation hdTimetableDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		descriptionLabel.hidden = YES;
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)changeDate:(id)sender {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		UIPopoverController *popoverViewController = [timetableViewController getPopoverController];
		[popoverViewController dismissPopoverAnimated:YES];
		[(hdTimetableTableViewController *)timetableViewController popoverControllerDidDismissPopover:popoverViewController];
	} else {
		[timetableViewController dismissModalViewControllerAnimated:YES];
		[timetableViewController popoverControllerDidDismissPopover:nil];
	}
}

- (void)setTimetableViewController:(id)timetableVC {
	timetableViewController = timetableVC;
}

- (void)viewDidUnload {
	[self setDatePicker:nil];
	descriptionLabel = nil;
	[super viewDidUnload];
}
@end
