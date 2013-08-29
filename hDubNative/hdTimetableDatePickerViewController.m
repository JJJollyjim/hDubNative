//
//  hdTimetableDatePickerViewController.m
//  hDubNative
//
//  Created by printfn on 10/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdDateUtils.h"
#import "hdTimetableDatePickerViewController.h"
#import "hdTimetableParser.h"
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
}

- (void)viewWillAppear:(BOOL)animated {
	self.datePicker.date = dateThatWillBeShownSoon;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)selectedNewDate:(id)sender {
    NSDate *date = self.datePicker.date;
    if ([hdDateUtils isWeekend:date] || [hdTimetableParser getSubjectForDay:date period:1] == nil) {
        date = [hdDateUtils correctDate:date];
        [self.datePicker setDate:date animated:YES];
    }
	[timetableViewController updateTimetableWithAnimation:self.datePicker.date];
}

// Called when 'done' button was tapped
- (IBAction)changeDate:(id)sender {
	[timetableViewController updateDateByDatePickerWithDate:self.datePicker.date];
	[timetableViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTimetableViewController:(id)timetableVC {
	timetableViewController = timetableVC;
}

- (void)setStartingDate:(NSDate *)date {
	dateThatWillBeShownSoon = date;
}

- (void)viewDidUnload {
	[self setDatePicker:nil];
	descriptionLabel = nil;
	[super viewDidUnload];
}
@end
