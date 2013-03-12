//
//  hdTimetableDatePickerViewController.h
//  hDubNative
//
//  Created by printfn on 10/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hdTimetableDatePickerViewController : UIViewController {
	id timetableViewController;
	__weak IBOutlet UILabel *descriptionLabel;
	NSDate *dateThatWillBeShownSoon;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)changeDate:(id)sender;
- (IBAction)selectedNewDate:(id)sender;
- (void)setTimetableViewController:(id)timetableVC;
- (void)setStartingDate:(NSDate *)date;

@end
