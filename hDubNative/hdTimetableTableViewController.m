//
//  hdTimetableTableViewController.m
//  hDubNative
//
//  Created by printfn on 7/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableTableViewController.h"
#import "hdJsonWrapper.h"
#import "hdTimetableParser.h"
#import "hdDateUtils.h"
#import "hdTimetableDatePickerViewController.h"

@implementation hdTimetableTableViewController

@synthesize bbi;

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
	
	[self updateTimetable:nil];
	
	[super viewDidLoad];
}

- (IBAction)swipeToNextDay:(id)sender {
	NSTimeInterval ti = 86400;
	dateShown = [dateShown dateByAddingTimeInterval:ti];
	[self updateTimetableWithAnimationLeft:nil];
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
	[self updateTimetableWithAnimationRight:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[self updateTimetable:nil];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Actions

hdTimetableDatePickerViewController *cache = nil;
- (IBAction)showDatePicker:(id)sender {
	NSString *storyboardName = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? @"Storyboard-iPhone" : @"Storyboard-iPad";
	if (cache == nil) {
		cache = [[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
		[cache setStartingDate:dateShown];
		[cache setTimetableViewController:self];
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
			datePickerPopover = [[UIPopoverController alloc] initWithContentViewController:cache];
			datePickerPopover.delegate = self;
		}
	}
	[cache setStartingDate:dateShown];
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
		[self presentModalViewController:cache animated:YES];
	} else {
		[datePickerPopover presentPopoverFromBarButtonItem:bbi permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"DatePickerSegue"]) {
		hdTimetableDatePickerViewController *target = segue.destinationViewController;
		[target setTimetableViewController:self];
		[target setStartingDate:dateShown];
	}
}

#pragma mark - UIPopoverControllerDelegate

- (void)updateDateByDatePickerWithDate:(NSDate *)date {
	dateShown = date;
	[self updateTimetable:nil];
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

- (void)updateTimetableWithAnimationLeft:(NSDate *)date {
	if (date != nil) {
		dateShown = date;
	}
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

- (void)updateTimetableWithAnimationRight:(NSDate *)date {
	if (date != nil) {
		dateShown = date;
	}
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
	__block UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(100, 20, 10000, 44)];
	bar.tintColor = [UIColor colorWithRed:135/255.0f green:10/255.0f blue:0.0f alpha:1.0f];
	[self.navigationController.view addSubview:bar];
	
	UINavigationItem* anItem = [[UINavigationItem alloc] initWithTitle:originalTitle];
	bar.items = [NSArray arrayWithObject:anItem];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[[[bar subviews] objectAtIndex:0] setAlpha:0];
	[[[bar subviews] objectAtIndex:1] setAlpha:0];
	[UIView commitAnimations];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
    bar = nil;
	});
}

- (void)viewDidUnload {
	[super viewDidUnload];
}
@end
