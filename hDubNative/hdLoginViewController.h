//
//  hdLoginViewController.h
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>

#import "hdStudent.h"

@interface hdLoginViewController : UIViewController <
UIAlertViewDelegate,
MFMailComposeViewControllerDelegate>

{
	NSString *bugReport;
	NSString *urlString;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicatorView;
@property (weak, nonatomic) IBOutlet UIProgressView *loginProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *hDubLogo;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;

- (IBAction)login:(id)sender;
- (IBAction)linkButtonPressed:(id)sender;

@end
