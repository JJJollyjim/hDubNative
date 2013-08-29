//
//  hdHomeworkViewController.m
//  hDubNative
//
//  Created by printfn on 16/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkViewController.h"
#import "hdDataStore.h"
#import "hdApiWrapper.h"
#import "hdJsonWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import "hdStudent.h"
#import "hdHomeworkTask.h"
#import "hdHomeworkDataStore.h"
#import "hdTimetableParser.h"
#import "hdHomeworkDetailViewController.h"
#import "hdHomeworkEditViewController.h"
#import "hdDateUtils.h"
#import "hdHomeworkSyncManager.h"

@implementation hdHomeworkViewController

@synthesize homeworkJsonString, homeworkDataStore;

- (id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.scrollsToTop = NO;
	UINavigationController *nav = self.navigationController;
	UINavigationBar *navBar = nav.navigationBar;
	navBar.tintColor = [UIColor colorWithRed:135/255.0f green:10/255.0f blue:0.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
	self.homeworkJsonString = [hdDataStore sharedStore].homeworkJson;
	self.homeworkDataStore = [hdHomeworkDataStore sharedStore];
    self.homeworkDataStore.tableView = self.tableView;
    self.syncManager = [hdHomeworkSyncManager sharedInstance];
    [self.syncManager syncAndPullChanges];
	[self.tableView reloadData];
	[self.homeworkDataStore scrollToTodayAnimated:NO];
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[hdHomeworkSyncManager sharedInstance] stopTimer];
	if ([segue.identifier isEqualToString:@"hdHomeworkDetailSegue"]) {
		UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
		hdHomeworkDetailViewController *detailViewController = (hdHomeworkDetailViewController *)navigationController.topViewController;
		UITableViewCell *selectedTableViewCell = (UITableViewCell *)sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedTableViewCell];
		hdHomeworkTask *homeworkTask = [self.homeworkDataStore homeworkTaskAtIndexPath:indexPath];
		detailViewController.homeworkTask = homeworkTask;
		detailViewController.homeworkViewController = self;
        detailViewController.homeworkDataStore = self.homeworkDataStore;
		detailViewController.section = indexPath.section;
		detailViewController.row = indexPath.row;
	} else if ([segue.identifier isEqualToString:@"hdHomeworkEditViewControllerSegueFromHomeworkViewController"]) {
		// New homework task
		hdHomeworkEditViewController *editViewController;
		UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
		editViewController = (hdHomeworkEditViewController *)navigationController.topViewController;
		editViewController.homeworkTask = [[hdHomeworkTask alloc] init];
		editViewController.previousViewController = self;
        editViewController.homeworkDataStore = self.homeworkDataStore;
		editViewController.newHomeworkTask = YES;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int sectionCount = [self.homeworkDataStore numberOfSections];
    [self updateBackgroundIfEmpty];
    return sectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.homeworkDataStore titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rowCount = [self.homeworkDataStore numberOfRowsInSection:section];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"hdHomeworkCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hdTimetableCell"];
	}
	
	hdHomeworkTask *hw = [self.homeworkDataStore homeworkTaskAtIndexPath:indexPath];
	cell.textLabel.text = hw.name;
	if (hw.period == 0) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"All day"];
    } else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (Period %i)", [hdTimetableParser getSubjectForDay:[hdDateUtils jsonDateToDate:hw.date] period:hw.period], hw.period];
	}
	
	return cell;
}

- (void)updateBackgroundIfEmpty {
	int sectionCount = [self.homeworkDataStore numberOfSections];
    if (sectionCount == 0) {
        UIImage *image = [UIImage imageNamed:@"Kwiius Logo.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:self.tableView.bounds];
        imageView.contentMode = UIViewContentModeCenter;
        [self.tableView setBackgroundView:imageView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        [self.tableView setBackgroundView:nil];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65;
}

- (IBAction)goToToday:(id)sender {
	[self.homeworkDataStore scrollToTodayAnimated:YES];
}

// User is editing the table view
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
        [self.homeworkDataStore deleteHomeworkTaskAtIndexPath:indexPath];
        [self updateBackgroundIfEmpty];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end