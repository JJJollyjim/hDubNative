//
//  hdLoginViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdLoginViewController.h"

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
	[loginButton setTitle:@"Logging in..." forState:UIControlStateDisabled];
	loginButton.enabled = NO;
	loginButton.alpha = 0.5;
	[usernameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	[[hdStudent sharedStudent] loginNewUser:usernameTextField.text.integerValue
															password:passwordTextField.text.integerValue
															callback:^(BOOL success, NSString *error) {
																loginProgressView.progress = 0.0;
																loginActivityIndicatorView.hidden = YES;
																[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
																loginProgressView.hidden = YES;
																loginButton.enabled = YES;
																loginButton.alpha = 1.0;
																if (!success) {
																	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
																	[av show];
																} else {
																	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"hDub" message:@"Success!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
																	[av show];
																}
															}
															progressbar:loginProgressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
