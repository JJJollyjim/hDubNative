//
//  hdSettingsViewController.m
//  hDubNative
//
//  Created by printfn on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdGeneralUtilities.h"
#import "hdSettingsViewController.h"
#import "hdTabViewController.h"
#import "hdStudent.h"

@implementation hdSettingsViewController

@synthesize sidLabel, logoutButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"Settings", @"Settings");
		self.tabBarItem.image = [UIImage imageNamed:@"settings"];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", [hdGeneralUtilities currentVersion]];
}

- (void)viewWillAppear:(BOOL)animated {
	sidLabel.text = [NSString stringWithFormat:@"%i", [hdDataStore sharedStore].userId];

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
	if (self.kwiiusButton.touchInside) {
		NSURL *url = [[NSURL alloc] initWithString:@"http://www.youtube.com/watch?v=9bZkp7q19f0"];
		[[UIApplication sharedApplication] openURL:url];
	}
}

- (IBAction)logout:(id)sender {
	[hdDataStore sharedStore].userLoggedIn = NO;
	[hdDataStore sharedStore].pass = -1;
	[hdDataStore sharedStore].homeworkJson = @"";
	[hdDataStore sharedStore].timetableJson = @"";
	id hdTabVC = self.tabBarController;
	[hdTabVC presentLoginViewControllerIfRequired];
}

- (IBAction)reloadTimetable:(id)sender {
	self.reloadTimetableButton.enabled = NO;
	self.reloadTimetableButton.alpha = 0.5;
	self.logoutButton.enabled = NO;
	self.logoutButton.alpha = 0.5;
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		[self.reloadTimetableButton setTitle:@"Reloading timetable…" forState:UIControlStateDisabled];
	} else {
		[self.reloadTimetableButton setTitle:@"Reloading…" forState:UIControlStateDisabled];
	}
    [[hdStudent sharedStudent] loginUser:[hdDataStore sharedStore].userId
                                password:[hdDataStore sharedStore].pass
                                callback:^(BOOL success, NSString *response, NSString *report) {
		self.reloadTimetableButton.enabled = YES;
		self.reloadTimetableButton.alpha = 1.0;
		self.logoutButton.enabled = YES;
		self.logoutButton.alpha = 1.0;
		
		if (!success) {
			bugReport = report;
			[[[UIAlertView alloc] initWithTitle:@"hDub" message:response delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Send Bug Report", nil] show];
		} else {
			[[[UIAlertView alloc] initWithTitle:@"hDub" message:@"Timetable and homework updated!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
		}
	}];
}

- (IBAction)openKwiiusWebsite:(id)sender {
	NSURL *url = [[NSURL alloc] initWithString:@"http://kwiius.com"];
	[[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Email

- (IBAction)sendEmail:(id)sender {
	if (![MFMailComposeViewController canSendMail]) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"hDub" message:@"No email accounts have been configured." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[av show];
	} else {
		MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
		mailer.mailComposeDelegate = self;
		[mailer setSubject:@"hDub Feedback"];
		[mailer setToRecipients:@[@"toby@kwiius.com"]];
		[self presentModalViewController:mailer animated:YES];
	}
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

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setVersionLabel:nil];
    [super viewDidUnload];
}
@end
