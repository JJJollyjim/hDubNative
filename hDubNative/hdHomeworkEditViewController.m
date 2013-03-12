//
//  hdHomeworkEditViewController.m
//  hDubNative
//
//  Created by printfn on 9/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkEditViewController.h"

@implementation hdHomeworkEditViewController

@synthesize previousViewController, cancelButton, doneButton;

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		// Custom initialization
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

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender {
	[self.previousViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
	[self.previousViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 3;
}

void nothing() {}

NSMutableDictionary *tableViewIndexToDoublePeriodOffsetMap;
NSMutableDictionary *periodToTableViewIndexMap;
NSMutableDictionary *tableViewIndexToHeightMap;
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
	switch (section) {
		case 0:
			return 2;
		case 1:
			return 1;
		case 2:
			nothing();
			tableViewIndexToDoublePeriodOffsetMap = [[NSMutableDictionary alloc] init];
			tableViewIndexToHeightMap = [[NSMutableDictionary alloc] init];
			periodToTableViewIndexMap = [[NSMutableDictionary alloc] init];
			int doublePeriodCount = 0;
			int lastOffsetValue = 0;
			int doublePeriodCountNegative = 0;
			for (int i = 0; i < 6; ++i) {
				nothing();
				NSString *lastSubject = [hdTimetableParser getSubjectForDay:_homeworkTask.date period:i-1];
				NSString *subject = [hdTimetableParser getSubjectForDay:_homeworkTask.date period:i];
				if (lastSubject != nil && [subject isEqualToString:lastSubject]) {
					doublePeriodCount++;
					doublePeriodCountNegative--;
				}
				[periodToTableViewIndexMap setObject:[NSNumber numberWithInt:i+1+doublePeriodCountNegative] forKey:[NSNumber numberWithInt:i+1]];
				[tableViewIndexToDoublePeriodOffsetMap setObject:[NSNumber numberWithInt:i+doublePeriodCount] forKey:[NSNumber numberWithInt:i+1]];
				[tableViewIndexToHeightMap setObject:[NSNumber numberWithInt:doublePeriodCount - lastOffsetValue] forKey:[NSNumber numberWithInt:i+1-doublePeriodCount+1]];
				doublePeriodCountNegative = doublePeriodCount;
				lastOffsetValue = doublePeriodCount;
				// 0 - 1
				// 1 - 3
				// 2 - 5
				// 3 - 6
				// 4 - 7
				// 5 - 8
			}
			NSLog(@"%@", tableViewIndexToDoublePeriodOffsetMap);
			return 7 - doublePeriodCount;
	}
	NSLog(@"ERROR!!!");
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section != 2)
		return 44.0;
	if (indexPath.row == 0) {
		return 44;
	}
	int x = ((NSNumber *)[tableViewIndexToHeightMap objectForKey:[NSNumber numberWithInt:indexPath.row]]).integerValue;
	return x == 0 ? 44 : 66;
}

- (int)getTableViewIndexFromPeriod:(int)idx {
	int t = 0;
	if (idx == 0)
		return 0;
	while (t == 0) {
		t = ((NSNumber *)[periodToTableViewIndexMap objectForKey:[NSNumber numberWithInt:idx]]).integerValue;
		idx--;
	}
	return t;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	if (indexPath.section != 2) {
		static NSString *CellIdentifier = @"hdHomeworkEditViewControllerCell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		}
	} else {
		static NSString *CellIdentifier = @"hdHomeworkEditViewControllerCellCheckbox";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
	}
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Name";
					cell.detailTextLabel.text = self.homeworkTask.name;
					break;
				case 1:
					cell.textLabel.text = @"Details";
					cell.detailTextLabel.text = self.homeworkTask.details.length < 20 ? self.homeworkTask.details : [NSString stringWithFormat:@"%@…", [self.homeworkTask.details substringToIndex:20]];
			}
			break;
		case 1:
			cell.textLabel.text = @"Date due";
			cell.detailTextLabel.text = [hdHomeworkEditViewController formatDate:self.homeworkTask.date];
			break;
		case 2:
			if (indexPath.row == 0) {
				cell.textLabel.text = @"All day";
			} else {
				cell.textLabel.text = [hdTimetableParser getSubjectForDay:self.homeworkTask.date
																													 period:((NSNumber *)([tableViewIndexToDoublePeriodOffsetMap objectForKey:
																																	 [NSNumber numberWithInt:indexPath.row]])).integerValue];
			}
			if (indexPath.row == [self getTableViewIndexFromPeriod:_homeworkTask.period]) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
			} else {
				cell.accessoryType = UITableViewCellAccessoryNone;
			}
			break;
	}
  
	return cell;
}

#pragma mark - Table view delegate

UITableViewCell *selectedCell;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section != 2) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}
	if (selectedCell) {
		selectedCell.accessoryType = UITableViewCellAccessoryNone;
	}
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	selectedCell = cell;
	_homeworkTask.period = indexPath.row;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

+ (NSString *)formatDate:(NSDate *)date {
	NSTimeInterval timeInterval =
	[[self dateAtMidnight:date] timeIntervalSinceReferenceDate]
	- [[self dateAtMidnight:[NSDate date]] timeIntervalSinceReferenceDate];
	int numOfDays = timeInterval / 86400;
	
	if (numOfDays == 0)
		return @"Today";
	
	if (numOfDays == 1)
		return @"Tomorrow";
	
	if (numOfDays == -1)
		return @"Yesterday";
	
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *componentsDateSpecified = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	NSDateComponents *componentsToday = [cal components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
	
	int month1 = componentsDateSpecified.month;
	int month2 = componentsToday.month;
	
	if (month1 == month2) {
		NSDateFormatter *f = [[NSDateFormatter alloc] init];
		[f setDateFormat:@"EEE d"];
		return [f stringFromDate:date];
	}
	
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	[f setDateFormat:@"EEE d MMM"];
	return [f stringFromDate:date];
}

+ (NSDate *)dateAtMidnight:(NSDate *)date {
	// Return a new date that has the same year,
	//  month and day components of the current date,
	//  but with the time set to 12:00 AM.
	NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
	return [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
}

- (void)viewDidUnload {
	[self setCancelButton:nil];
	[self setDoneButton:nil];
	[super viewDidUnload];
}

@end
