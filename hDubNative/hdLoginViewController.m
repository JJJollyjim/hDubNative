//
//  hdLoginViewController.m
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "hdLoginViewController.h"
#import "hdTabViewController.h"
#import "hdNotificationApi.h"

@implementation hdLoginViewController

@synthesize loginButton, usernameTextField,
passwordTextField, loginActivityIndicatorView, loginProgressView, messageTextView, messageTitleLabel, linkButton;

- (void)receiveMessage:(NSNotification *)notification {
	NSDictionary *messageInfoDict = notification.userInfo;
	if ([messageInfoDict objectForKey:@"message_title"] == nil) {
		messageTextView.text = @"";
		messageTitleLabel.text = @"";
		linkButton.enabled = false;
		linkButton.alpha = 0.0;
		return;
	}
	self.messageTitleLabel.text = [NSString stringWithFormat:@"%@:", (NSString *)([messageInfoDict objectForKey:@"message_title"])];;
	self.messageTextView.text = [messageInfoDict objectForKey:@"message"];
	if ([messageInfoDict objectForKey:@"link"] == nil) {
		linkButton.enabled = false;
		linkButton.alpha = 0.0;
		[linkButton setTitle:@"" forState:UIControlStateNormal];
	} else {
		linkButton.enabled = true;
		linkButton.alpha = 1.0;
		[linkButton setTitle:[messageInfoDict objectForKey:@"link_title"] forState:UIControlStateNormal];
		urlString = [messageInfoDict objectForKey:@"link"];
	}
}

- (IBAction)linkButtonPressed:(id)sender {
	NSURL *url = [NSURL URLWithString:urlString];
	[[UIApplication sharedApplication] openURL:url];
}

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
	[hdNotificationApi setOnLoginScreen:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:@"hdShowMessage" object:nil];
	BOOL showLargeHdubLogo = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
	|| [UIScreen mainScreen].bounds.size.height == 568.0;
	if (showLargeHdubLogo) {
		self.hDubLogo.layer.anchorPoint = CGPointMake(0,0);
		CGRect frame = CGRectMake(20,
															20,
															280,
															148);
		self.hDubLogo.frame = frame;
		int distance = 74;
		self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x,
																				self.loginButton.frame.origin.y + distance,
																				self.loginButton.frame.size.width,
																				self.loginButton.frame.size.height);
		
		self.usernameTextField.frame = CGRectMake(self.usernameTextField.frame.origin.x,
																							self.usernameTextField.frame.origin.y + distance,
																							self.usernameTextField.frame.size.width,
																							self.usernameTextField.frame.size.height);
		
		self.usernameLabel.frame = CGRectMake(self.usernameLabel.frame.origin.x,
																					self.usernameLabel.frame.origin.y + distance,
																					self.usernameLabel.frame.size.width,
																					self.usernameLabel.frame.size.height);
		
		self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x,
																							self.passwordTextField.frame.origin.y + distance,
																							self.passwordTextField.frame.size.width,
																							self.passwordTextField.frame.size.height);
		
		self.passwordLabel.frame = CGRectMake(self.passwordLabel.frame.origin.x,
																					self.passwordLabel.frame.origin.y + distance,
																					self.passwordLabel.frame.size.width,
																					self.passwordLabel.frame.size.height);
	}
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		[messageTitleLabel layer].anchorPoint = CGPointMake(0, 0);
		[messageTitleLabel setCenter:CGPointMake(20, 170)];
		[messageTextView layer].anchorPoint = CGPointMake(0, 0);
		messageTextView.frame = CGRectMake(20, 210, 280, 180);
	}
	[hdNotificationApi updateNow];
}

BOOL currentlyLoggingIn = NO;
- (IBAction)login:(id)sender {
	if (currentlyLoggingIn)
		return;
	currentlyLoggingIn = YES;
	loginActivityIndicatorView.hidden = NO;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[hdStudent initialize];
	loginProgressView.hidden = NO;
	//loginButton.enabled = NO;
	loginButton.alpha = 0;
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
																currentlyLoggingIn = NO;
																if (!success) {
																	bugReport = devError;
																	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Report Error", nil];
																	[av show];
																} else {
																	[hdNotificationApi setOnLoginScreen:NO];
																	[[NSNotificationCenter defaultCenter] removeObserver:self];
																	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
																	[(hdTabViewController *)self.presentingViewController updateSubviews];
																}
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
