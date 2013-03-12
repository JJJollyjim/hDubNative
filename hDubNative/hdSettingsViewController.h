//
//  hdSettingsViewController.h
//  hDubNative
//
//  Created by printfn on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "hdDataStore.h"

@interface hdSettingsViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
	NSString *bugReport;
}

@property (weak, nonatomic) IBOutlet UILabel *sidLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *reloadTimetableButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *formLabel;
@property (weak, nonatomic) IBOutlet UIButton *kwiiusButton;

- (IBAction)logout:(id)sender;
- (IBAction)reloadTimetable:(id)sender;
- (IBAction)openKwiiusWebsite:(id)sender;
- (IBAction)sendEmail:(id)sender;

@end
