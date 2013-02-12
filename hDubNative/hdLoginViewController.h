//
//  hdLoginViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "hdStudent.h"

@interface hdLoginViewController : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
	NSString *bugReport;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UIProgressView *loginProgressView;

- (IBAction)login:(id)sender;

@end
