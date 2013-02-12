//
//  hdTimetableDatePickerViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 10/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hdTimetableDatePickerViewController : UIViewController {
	id timetableViewController;
	__weak IBOutlet UILabel *descriptionLabel;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)changeDate:(id)sender;
- (void)setTimetableViewController:(id)timetableVC;

@end
