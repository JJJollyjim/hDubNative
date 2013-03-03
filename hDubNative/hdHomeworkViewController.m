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

@interface hdHomeworkViewController ()

@property (nonatomic) NSString *homeworkJsonString;
@property (nonatomic) hdHomeworkDataStore *parser;

@end

@implementation hdHomeworkViewController

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
	
	UINavigationController *nav = self.navigationController;
	UINavigationBar *navBar = nav.navigationBar;
	navBar.tintColor = [UIColor colorWithRed:135/255.0f green:10/255.0f blue:0.0f alpha:1.0f];
}

- (void)viewWillAppear:(BOOL)animated {
	self.homeworkJsonString = [hdDataStore sharedStore].homeworkJson;
	self.parser = [[hdHomeworkDataStore alloc] init];
	[self.tableView reloadData];
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
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (Period %i)", hw.subject, hw.period];
	
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

 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		BOOL deletedSections = [self.parser deleteCellAtDayIndex:indexPath.section id:indexPath.row];
		
		[tableView beginUpdates];
		if (deletedSections) {
			[tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
		} else {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
