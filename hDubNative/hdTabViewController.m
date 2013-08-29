//
//  hdTabViewController.m
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdDataStore.h"
#import "hdTabViewController.h"
#import "hdTimetableTableViewController.h"

@implementation hdTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
	[self presentLoginViewControllerIfRequired];
}

- (void)presentLoginViewControllerIfRequired {
	if (![hdDataStore sharedStore].userLoggedIn) {
		loginViewController = [[hdLoginViewController alloc] initWithNibName:@"hdLoginViewController" bundle:nil];
		loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentViewController:loginViewController animated:YES completion:nil];
	}
}

- (void)updateSubviews {
	UINavigationController *navController = (UINavigationController *)self.viewControllers[0];
	hdTimetableTableViewController *tttvc = (hdTimetableTableViewController *)navController.viewControllers[0];
	[tttvc viewWillAppear:YES];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tabBar.tintColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
