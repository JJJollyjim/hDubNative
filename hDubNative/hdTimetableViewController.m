//
//  hdFirstViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableViewController.h"

#import "hdHTTPWrapper.h"

@interface hdTimetableViewController ()

@end

@implementation hdTimetableViewController

@synthesize textView;

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
	
	
	/*hdHTTPWrapper *wrapper = [[hdHTTPWrapper alloc] init];
	
	[wrapper getTimetableForUser:9079
															password:9391
															 success:^void (NSString *response) {
																 NSLog(@"Response: %@", response);
																 textView.text = response;
															 }
																 error:^void (NSString *errorMsg) {
																	 NSLog(@"Error Callback! %@", errorMsg);
																	 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error!"
																																								message:errorMsg
																																							 delegate:nil
																																			cancelButtonTitle:@"Close"
																																			otherButtonTitles:nil];
																	 [av show];
																 }];*/
}

							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
