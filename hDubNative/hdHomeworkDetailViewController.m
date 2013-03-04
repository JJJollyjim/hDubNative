//
//  hdHomeworkDetailViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 3/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkDetailViewController.h"
#import "hdDateUtils.h"

@implementation hdHomeworkDetailViewController

@synthesize homeworkTask, homeworkTitle, homeworkDetailTextView, homeworkDataTableView, homeworkViewController, noDetailsLabel;

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
	homeworkDataTableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
	homeworkTitle.text = homeworkTask.name;
	if (homeworkTask.details == nil || [homeworkTask.details isEqualToString:@""]) {
		noDetailsLabel.hidden = NO;
		homeworkDetailTextView.hidden = YES;
	} else {
		noDetailsLabel.hidden = YES;
		homeworkDetailTextView.hidden = NO;
		homeworkDetailTextView.text = homeworkTask.details;
	}
	self.title = [NSString stringWithFormat:@"%@ Homework", homeworkTask.subject];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"hdHomeworkDetailViewControllerCell";
	UITableViewCell *cell = [homeworkDataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"hdHomeworkDetailViewControllerCell"];
	}
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Subject";
		cell.detailTextLabel.text = homeworkTask.subject;
	} else {
		cell.textLabel.text = @"Due";
		cell.detailTextLabel.text = [NSString stringWithFormat:@"Period %i, %@", homeworkTask.period, [hdDateUtils formatDate:homeworkTask.date]];
	}

	
	return cell;
}

@end
