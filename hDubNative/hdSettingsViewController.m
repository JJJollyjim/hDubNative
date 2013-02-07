//
//  hdSettingsViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdSettingsViewController.h"
#import "hdTabViewController.h"

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
	sidLabel.text = [NSString stringWithFormat:@"%i", [hdDataStore sharedStore].userId];
	// Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
	[hdDataStore sharedStore].userLoggedIn = NO;
	[hdDataStore sharedStore].pass = -1;
	[hdDataStore sharedStore].homeworkJson = @"";
	[hdDataStore sharedStore].timetableJson = @"";
	id hdTabVC = self.tabBarController;
	[hdTabVC presentLoginViewControllerIfRequired];
}

@end
