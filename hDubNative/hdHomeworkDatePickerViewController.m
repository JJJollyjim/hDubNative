//
//  hdHomeworkDatePickerViewController.m
//  hDubNative
//
//  Created by printfn on 23/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkDatePickerViewController.h"
#import "hdHomeworkEditViewController.h"
#import "hdDateUtils.h"

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

- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}

- (IBAction)datePickerValueChanged:(id)sender {
	NSTimeInterval ti = 86400;
	for (;;) {
		if ([hdDateUtils isWeekend:self.datePicker.date] || [hdTimetableParser getSubjectForDay:self.datePicker.date period:1] == nil) {
			[self.datePicker setDate:[self.datePicker.date dateByAddingTimeInterval:ti] animated:YES];
		} else {
			break;
		}
	}
	hdHomeworkEditViewController *editVC = (hdHomeworkEditViewController *)self.editViewController;
	[editVC datePickerViewControllerSetDate:self.datePicker.date];
}

@end
