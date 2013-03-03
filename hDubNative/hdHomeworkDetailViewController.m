//
//  hdHomeworkDetailViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 3/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkDetailViewController.h"

@implementation hdHomeworkDetailViewController

@synthesize homeworkTask, homeworkTitle, homeworkDetailTextView, homeworkDataTableView, homeworkViewController;

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
	// Do any additional setup after loading the view.
	
	UINavigationController *nav = self.navigationController;
	UINavigationBar *navBar = nav.navigationBar;
	navBar.tintColor = [UIColor colorWithRed:135/255.0f green:10/255.0f blue:0.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
	homeworkTitle.text = homeworkTask.name;
	homeworkDetailTextView.text = homeworkTask.details;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setHomeworkDataTableView:nil];
	[self setHomeworkDetailTextView:nil];
	[super viewDidUnload];
}

- (IBAction)done:(id)sender {
	[homeworkViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editHomeworkTask:(id)sender {
}

- (IBAction)deleteHomeworkTask:(id)sender {
}
@end
