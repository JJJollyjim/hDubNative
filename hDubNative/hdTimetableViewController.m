//
//  hdFirstViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableViewController.h"

#import "hdHTTPWrapper.h"

@implementation hdTimetableViewController

@synthesize timetableTableView, titleNavigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Timetable", @"Timetable");
		self.tabBarItem.image = [UIImage imageNamed:@"timetable"];
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

							
- (void)viewDidLoad
{
	[super viewDidLoad];
	dataSource = [[hdTimetableDataSource alloc] init];
	timetableTableView.dataSource = dataSource;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
