//
//  hdHomeworkDatePickerViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 23/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hdHomeworkDatePickerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) id editViewController;
@property (nonatomic) NSDate *dateToDisplay;

- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)dismissDatePickerViewController:(id)sender;

@end
