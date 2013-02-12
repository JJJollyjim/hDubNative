//
//  hdTimetableTableViewController.m
//  hDubNative
//
//  Created by Jamie McClymont on 7/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableTableViewController.h"
#import "hdJsonWrapper.h"
#import "hdTimetableParser.h"
#import "hdDateUtils.h"
#import "hdTimetableDatePickerViewController.h"

@implementation hdTimetableTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
	}
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	[self updateTimetable:nil];
	if (self) {
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
	}
	return self;
}

- (id)init {
	self = [super init];
	[self updateTimetable:nil];
	return self;
}

- (void)viewDidLoad {
	UISwipeGestureRecognizer *swipeGestureObjectImg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToNextDay:)];
	swipeGestureObjectImg.numberOfTouchesRequired = 1;
	swipeGestureObjectImg.direction = (UISwipeGestureRecognizerDirectionLeft);
	[self.view addGestureRecognizer:swipeGestureObjectImg];
	
	UISwipeGestureRecognizer *swipeGestureRightObjectImg = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToPreviousDay:)];
	swipeGestureRightObjectImg.numberOfTouchesRequired = 1;
	swipeGestureRightObjectImg.direction = (UISwipeGestureRecognizerDirectionRight);
	[self.view addGestureRecognizer:swipeGestureRightObjectImg];
	
	UINavigationController *nav = self.navigationController;
	UINavigationBar *navBar = nav.navigationBar;
	navBar.tintColor = [UIColor colorWithRed:135/255.0f green:10/255.0f blue:0.0f alpha:1.0f];
	
	dateViewControllerCurrentlyShowing = NO;
	UIStoryboard *storyBoard = [self storyboard];
	datePickerViewController = [storyBoard instantiateViewControllerWithIdentifier:@"hdTimetableDatePickerViewController"];
	[datePickerViewController setTimetableViewController:self];
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		datePickerPopover = [[UIPopoverController alloc] initWithContentViewController:datePickerViewController];
		bbi = self.navigationItem.leftBarButtonItem;
		datePickerPopover.popoverContentSize = CGSizeMake(320, 260);
		datePickerPopover.delegate = self;
	}
	
	[self updateTimetable:nil];
	
	[super viewDidLoad];
}

- (IBAction)swipeToNextDay:(id)sender {
	NSTimeInterval ti = 86400;
	dateShown = [dateShown dateByAddingTimeInterval:ti];
	[self updateTimetableWithAnimationLeft];
}

- (IBAction)swipeToPreviousDay:(id)sender {
	NSTimeInterval ti = -86400;
	dateShown = [dateShown dateByAddingTimeInterval:ti];
	for (;;) {
		if ([hdDateUtils isWeekend:dateShown]) {
			dateShown = [dateShown dateByAddingTimeInterval:ti];
		} else {
			break;
		}
	}
	[self updateTimetableWithAnimationRight];
}

- (void)viewDidAppear:(BOOL)animated {
	dateShown = [NSDate date];
	[self updateTimetable:nil];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)showDatePicker:(id)sender {
	if (dateViewControllerCurrentlyShowing == NO) {
		dateViewControllerCurrentlyShowing = YES;
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
			[self presentViewController:datePickerViewController animated:YES completion:nil];
		} else {
			[datePickerPopover presentPopoverFromBarButtonItem:bbi permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
		}
	} else {
		[datePickerPopover dismissPopoverAnimated:YES];
		[self popoverControllerDidDismissPopover:datePickerPopover];
		dateViewControllerCurrentlyShowing = NO;
	}
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	dateViewControllerCurrentlyShowing = NO;
	dateShown = [datePickerViewController datePicker].date;
	[self updateTimetable:nil];
}

- (UIPopoverController *)getPopoverController {
	return datePickerPopover;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (!dateShown) {
		dateShown = [NSDate date];
	}
	for (;;) {
		if ([hdDateUtils isWeekend:dateShown]) {
			dateShown = [dateShown dateByAddingTimeInterval:86400];
		} else {
			break;
		}
	}
	
	self.title = [hdDateUtils formatDate:dateShown];
	self.navigationController.title = @"Timetable";
	
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"hdTimetableCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hdTimetableCell"];
	}
	// Configure the cell...
	NSString *subject = [hdTimetableParser getSubjectForDay:dateShown period:indexPath.row rootObj:timetableRootObject];
	cell.textLabel.text = subject;
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 */
}

- (IBAction)updateTimetable:(id)sender {
	sharedStore = [hdDataStore sharedStore];
	timetableRootObject = [hdJsonWrapper getObj:sharedStore.timetableJson];
	[self.tableView reloadData];
}

- (void)updateTimetableWithAnimationLeft {
	NSString *oldTitle = self.title;
	[(UITableView *)self.view reloadRowsAtIndexPaths:
	 @[
	 [NSIndexPath indexPathForRow:0 inSection:0],
	 [NSIndexPath indexPathForRow:1 inSection:0],
	 [NSIndexPath indexPathForRow:2 inSection:0],
	 [NSIndexPath indexPathForRow:3 inSection:0],
	 [NSIndexPath indexPathForRow:4 inSection:0],
	 [NSIndexPath indexPathForRow:5 inSection:0]
	 ]
																	withRowAnimation:UITableViewRowAnimationLeft];
	[self replaceDateWithFadeAnimation:oldTitle];
}

- (void)updateTimetableWithAnimationRight {
	NSString *oldTitle = self.title;
	[(UITableView *)self.view reloadRowsAtIndexPaths:
	 @[
	 [NSIndexPath indexPathForRow:0 inSection:0],
	 [NSIndexPath indexPathForRow:1 inSection:0],
	 [NSIndexPath indexPathForRow:2 inSection:0],
	 [NSIndexPath indexPathForRow:3 inSection:0],
	 [NSIndexPath indexPathForRow:4 inSection:0],
	 [NSIndexPath indexPathForRow:5 inSection:0]
	 ]
																	withRowAnimation:UITableViewRowAnimationRight];
	[self replaceDateWithFadeAnimation:oldTitle];
}

- (void)replaceDateWithFadeAnimation:(NSString *)originalTitle {
	UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(100, 20, 568, 44)];
	bar.tintColor = [UIColor colorWithRed:135/255.0f green:10/255.0f blue:0.0f alpha:1.0f];
	[self.navigationController.view addSubview:bar];
	
	UINavigationItem* anItem = [[UINavigationItem alloc] initWithTitle:originalTitle];
	//UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
	//UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
	//anItem.leftBarButtonItem = leftItem;
	//anItem.rightBarButtonItem = rightItem;
	bar.items = [NSArray arrayWithObject:anItem];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[[[bar subviews] objectAtIndex:0] setAlpha:0];
	[[[bar subviews] objectAtIndex:1] setAlpha:0];
	//[[[bar subviews] objectAtIndex:2] setAlpha:0];
	[UIView commitAnimations];
	
	
}

- (void)viewDidUnload {
	[super viewDidUnload];
}
@end
