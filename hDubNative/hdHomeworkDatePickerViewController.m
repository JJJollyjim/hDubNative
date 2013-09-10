//
//  hdHomeworkDatePickerViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 23/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "NSDate+DateComponents.h"
#import "hdDateUtils.h"
#import "hdHomeworkDatePickerViewController.h"
#import "hdHomeworkEditViewController.h"

@implementation hdHomeworkDatePickerViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.datePicker setMinimumDate:[NSDate date]];
    [self.datePicker setMaximumDate:[NSDate dateWithYear:2013 month:12 day:31]];
	[self.datePicker setDate:self.dateToDisplay animated:NO];
}

- (void)viewDidUnload {
	[self setDatePicker:nil];
	[super viewDidUnload];
}

+ (NSDate *)correctDate:(NSDate *)date {
	NSDate *prevDate = date;
	int iterations = 0;
	for (;;) {
		iterations++;
		if ([hdDateUtils isWeekend:date] || [hdTimetableParser getSubjectForDay:date period:1] == nil) {
			date = [date dateByAddingTimeInterval:86400];
			if (iterations >= 366) {
				date = prevDate;
				iterations = 0;
				for (;;) {
					iterations++;
					if ([hdDateUtils isWeekend:date] || [hdTimetableParser getSubjectForDay:date period:1] == nil) {
						date = [date dateByAddingTimeInterval:-86400];
						if (iterations >= 366) {
							break;
						}
					} else {
						break;
					}
				}
				break;
			}
		} else {
			break;
		}
	}
	return date;
}

- (IBAction)datePickerValueChanged:(id)sender {
    NSDate *date = self.datePicker.date;
    if ([hdDateUtils isWeekend:date] || [hdTimetableParser getSubjectForDay:date period:1] == nil) {
        date = [hdDateUtils correctDate:date];
        [self.datePicker setDate:date animated:YES];
    }
	hdHomeworkEditViewController *editVC = (hdHomeworkEditViewController *)self.editViewController;
	[editVC datePickerViewControllerSetDate:self.datePicker.date];
}

// Only runs on iPhone since iPad uses UIPopoverController
- (IBAction)dismissDatePickerViewController:(id)sender {
    hdHomeworkEditViewController *editViewController = (hdHomeworkEditViewController *)self.editViewController;
    [editViewController dismissModalViewControllerAnimated:YES];
}

@end
