//
//  hdLoginViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdLoginViewController.h"
#import "hdTabViewController.h"

@implementation hdLoginViewController

@synthesize loginButton, usernameTextField,
passwordTextField, loginActivityIndicatorView, loginProgressView;

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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)login:(id)sender {
	loginActivityIndicatorView.hidden = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[hdStudent initialize];
	[loginProgressView setProgress:0.0];
	loginProgressView.hidden = NO;
	loginButton.enabled = NO;
	loginButton.alpha = 0.5;
	[usernameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	[[hdStudent sharedStudent] loginNewUser:usernameTextField.text.integerValue
															password:passwordTextField.text.integerValue
															callback:^(BOOL success, NSString *error, NSString *devError) {
																loginProgressView.progress = 0.0;
																loginActivityIndicatorView.hidden = YES;
																[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
																loginProgressView.hidden = YES;
																loginButton.enabled = YES;
																loginButton.alpha = 1.0;
																if (!success) {
																	bugReport = devError;
																	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Send Bug Report", nil];
																	[av show];
																} else {
																	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
																	[(hdTabViewController *)self.presentingViewController updateSubviews];
																}
															}
															progressCallback:^(float progress, NSString *status) {
																loginProgressView.progress = progress;
																[loginButton setTitle:status forState:UIControlStateDisabled];
															}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		// Send error report
		[self sendBugReport:bugReport];
	}
}

- (void)sendBugReport:(NSString *)report {
	if (![MFMailComposeViewController canSendMail]) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"hDub" message:@"No email accounts have been configured." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[av show];
	} else {
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
		mailer.mailComposeDelegate = self;
		[mailer setMessageBody:report isHTML:NO];
		[mailer setSubject:@"hDub Bug Report (iOS)"];
		[mailer setToRecipients:@[@"toby@kwiius.com"]];
		[self presentModalViewController:mailer animated:YES];
	}
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
					didFinishWithResult:(MFMailComposeResult)result
												error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
