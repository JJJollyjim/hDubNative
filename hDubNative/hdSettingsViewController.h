//
//  hdSettingsViewController.h
//  hDubNative
//
//  Created by printfn on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>

#import "hdDataStore.h"

@interface hdSettingsViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
	NSString *bugReport;
}

@property (weak, nonatomic) IBOutlet UILabel *sidLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *reloadTimetableButton;
@property (weak, nonatomic) IBOutlet UIButton *kwiiusButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

- (IBAction)logout:(id)sender;
- (IBAction)reloadTimetable:(id)sender;
- (IBAction)openKwiiusWebsite:(id)sender;
- (IBAction)sendEmail:(id)sender;

@end
