//
//  hdTabViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTabViewController.h"
#import "hdDataStore.h"

@interface hdTabViewController ()

@end

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

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
