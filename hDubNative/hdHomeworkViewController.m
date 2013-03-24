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

@implementation hdHomeworkViewController

@synthesize homeworkJsonString, parser;

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.tableView.scrollsToTop = NO;
	UINavigationController *nav = self.navigationController;
	UINavigationBar *navBar = nav.navigationBar;
	navBar.tintColor = [UIColor colorWithRed:135/255.0f green:10/255.0f blue:0.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
	self.homeworkJsonString = [hdDataStore sharedStore].homeworkJson;
	self.parser = [[hdHomeworkDataStore alloc] init];
	[self.tableView reloadData];
	int sectionToScrollTo = [self.parser sectionToScrollToWhenTableViewBecomesVisible];
	if ([self.parser numberOfSectionsInTableView] != 0)
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
																															inSection:(sectionToScrollTo == -1 ? ([self.parser numberOfSectionsInTableView] - 1) : sectionToScrollTo)]
													atScrollPosition:UITableViewScrollPositionTop
																	 animated:NO];
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"hdHomeworkDetailSegue"]) {
		UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
		hdHomeworkDetailViewController *detailViewController = (hdHomeworkDetailViewController *)navigationController.topViewController;
		UITableViewCell *selectedTableViewCell = (UITableViewCell *)sender;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedTableViewCell];
		hdHomeworkTask *homeworkTask = [self.parser getHomeworkTaskForSection:indexPath.section id:indexPath.row];
		detailViewController.homeworkTask = homeworkTask;
		detailViewController.homeworkViewController = self;
		detailViewController.section = indexPath.section;
		detailViewController.dayIndex = indexPath.row;
	} else if ([segue.identifier isEqualToString:@"hdHomeworkEditViewControllerSegueFromHomeworkViewController"]) {
		// New homework task
		hdHomeworkEditViewController *editViewController;
		UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
		editViewController = (hdHomeworkEditViewController *)navigationController.topViewController;
		editViewController.homeworkTask = [[hdHomeworkTask alloc] init];
		NSTimeInterval ti = 86400;
		for (;;) {
			if ([hdDateUtils isWeekend:editViewController.homeworkTask.date] || [hdTimetableParser getSubjectForDay:editViewController.homeworkTask.date period:1] == nil) {
				editViewController.homeworkTask.date = [editViewController.homeworkTask.date dateByAddingTimeInterval:ti];
			} else {
				break;
			}
		}
		editViewController.previousViewController = self;
		editViewController.newHomeworkTask = YES;
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.parser numberOfSectionsInTableView];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.parser getTableSectionHeadingForDayId:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.parser numberOfCellsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"hdHomeworkCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hdTimetableCell"];
	}
	
	hdHomeworkTask *hw = [self.parser getHomeworkTaskForSection:indexPath.section id:indexPath.row];
	cell.textLabel.text = hw.name;
	if (hw.period == 0) {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"All day"];
	} else {
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (Period %i)", hw.subject, hw.period];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65;
}

 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Return NO if you do not want the specified item to be editable.
	return YES;
}

- (void)setHomeworkTask:(hdHomeworkTask *)homeworkTask inSection:(int)section row:(int)row {
	[self.parser setHomeworkTask:homeworkTask tableView:self.tableView section:section row:row];
}

- (void)deleteHomeworkTaskWithSection:(int)section dayIndex:(int)dayIndex {
	BOOL deletedSections = [self.parser deleteCellAtDayIndex:section id:dayIndex];
	
	[self.tableView beginUpdates];
	if (deletedSections) {
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section]
									withRowAnimation:UITableViewRowAnimationLeft];
	} else {
		[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:dayIndex inSection:section]]
													withRowAnimation:UITableViewRowAnimationLeft];
	}
	[self.tableView endUpdates];
}

 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		BOOL deletedSections = [self.parser deleteCellAtDayIndex:indexPath.section id:indexPath.row];
		
		[tableView beginUpdates];
		if (deletedSections) {
			[tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
		} else {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
		}
		[tableView endUpdates];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
