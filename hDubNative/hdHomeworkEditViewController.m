//
//  hdHomeworkEditViewController.m
//  hDubNative
//
//  Created by printfn on 9/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkViewController.h"
#import "hdHomeworkEditViewController.h"
#import "hdHomeworkDetailViewController.h"
#import "hdHomeworkDatePickerViewController.h"
#import "hdDateUtils.h"

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
	_homeworkTask.name = nameTextField.text;
	_homeworkTask.details = detailsTextView.text;
	if (!self.newHomeworkTask) {
		hdHomeworkDetailViewController *pvc = (hdHomeworkDetailViewController *)self.previousViewController;
		pvc.homeworkTask = _homeworkTask;
		[pvc updateHomeworkTask:_homeworkTask];
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
			[self.previousViewController dismissViewControllerAnimated:YES completion:nil];
		} else {
			[self.navigationController popViewControllerAnimated:YES];
		}
	} else {
        _homeworkTask.subject = [hdTimetableParser getSubjectForDay:_homeworkTask.date period:_homeworkTask.period - 1];
        _homeworkTask.room = [hdTimetableParser getRoomForDay:_homeworkTask.date period:_homeworkTask.period - 1];
        _homeworkTask.teacher = [hdTimetableParser getTeacherForDay:_homeworkTask.date period:_homeworkTask.period - 1];
		hdHomeworkViewController *pvc = (hdHomeworkViewController *)self.previousViewController;
		[pvc setHomeworkTask:_homeworkTask inSection:0 row:0];
		[self.previousViewController dismissViewControllerAnimated:YES completion:nil];
	}
}

- (IBAction)cancel:(id)sender {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
		[self.previousViewController dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

// Save date from datePickerViewController
- (void)datePickerViewControllerSetDate:(NSDate *)date {
	[self.tableView beginUpdates];
	NSDate *oldDate = _homeworkTask.date;
	int oldPeriodCount = [self.tableView numberOfRowsInSection:2]-1;
	_homeworkTask.date = date;
	int newPeriodCount = [self tableView:self.tableView numberOfRowsInSection:2]-1;
	if (oldPeriodCount == newPeriodCount) {
		NSMutableArray *rowsToReload = [[NSMutableArray alloc] init];
		for (int i = 1; i < newPeriodCount+1; ++i)
			[rowsToReload addObject:[NSIndexPath indexPathForRow:i inSection:2]];
		
		if (date.timeIntervalSinceReferenceDate > oldDate.timeIntervalSinceReferenceDate)
			[self.tableView reloadRowsAtIndexPaths:rowsToReload
                                  withRowAnimation:UITableViewRowAnimationLeft];
		else
			[self.tableView reloadRowsAtIndexPaths:rowsToReload
                                  withRowAnimation:UITableViewRowAnimationRight];
	} else {
		int minPeriodCount = oldPeriodCount < newPeriodCount ? oldPeriodCount : newPeriodCount;
		NSMutableArray *rowsToReload = [[NSMutableArray alloc] init];
		for (int i = 1; i < minPeriodCount+1; ++i)
			[rowsToReload addObject:[NSIndexPath indexPathForRow:i inSection:2]];
		
		if (date.timeIntervalSinceReferenceDate > oldDate.timeIntervalSinceReferenceDate)
			[self.tableView reloadRowsAtIndexPaths:rowsToReload
                                  withRowAnimation:UITableViewRowAnimationLeft];
		else
			[self.tableView reloadRowsAtIndexPaths:rowsToReload
                                  withRowAnimation:UITableViewRowAnimationRight];
		if (oldPeriodCount < newPeriodCount) {
			// new periods added
			NSMutableArray *rowsToReload = [[NSMutableArray alloc] init];
			for (int i = 0; i < newPeriodCount - oldPeriodCount; ++i)
				[rowsToReload addObject:[NSIndexPath indexPathForRow:minPeriodCount + 1 + i inSection:2]];
			
			if (date.timeIntervalSinceReferenceDate > oldDate.timeIntervalSinceReferenceDate)
				[self.tableView insertRowsAtIndexPaths:rowsToReload
															withRowAnimation:UITableViewRowAnimationRight];
			else
				[self.tableView insertRowsAtIndexPaths:rowsToReload
															withRowAnimation:UITableViewRowAnimationLeft];
		} else if (oldPeriodCount > newPeriodCount) {
			// old periods removed
			NSMutableArray *rowsToReload = [[NSMutableArray alloc] init];
			for (int i = 0; i < oldPeriodCount - newPeriodCount; ++i)
				[rowsToReload addObject:[NSIndexPath indexPathForRow:minPeriodCount + 1 + i inSection:2]];
			
			if (date.timeIntervalSinceReferenceDate > oldDate.timeIntervalSinceReferenceDate)
				[self.tableView deleteRowsAtIndexPaths:rowsToReload
															withRowAnimation:UITableViewRowAnimationLeft];
			else
				[self.tableView deleteRowsAtIndexPaths:rowsToReload
															withRowAnimation:UITableViewRowAnimationRight];
		}
	}
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                          withRowAnimation:UITableViewRowAnimationNone];
	[self.tableView endUpdates];
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
				BOOL incrementedI = NO;
				while (true) {
					NSString *subject = [hdTimetableParser getSubjectForDay:_homeworkTask.date period:i];
					if (lastSubject != nil && [subject isEqualToString:lastSubject]) {
						doublePeriodCount++;
						doublePeriodCountNegative--;
						++i;
						incrementedI = YES;
					} else {
						break;
					}
				}
				if (incrementedI)
					i--;
				[periodToTableViewIndexMap setObject:[NSNumber numberWithInt:i+doublePeriodCount] forKey:[NSNumber numberWithInt:i+1]];
				[tableViewIndexToDoublePeriodOffsetMap setObject:[NSNumber numberWithInt:i+doublePeriodCount] forKey:[NSNumber numberWithInt:i+1]];
				[tableViewIndexToHeightMap setObject:[NSNumber numberWithInt:doublePeriodCount - lastOffsetValue] forKey:[NSNumber numberWithInt:i-doublePeriodCount+1]];
				doublePeriodCountNegative = doublePeriodCount;
				lastOffsetValue = doublePeriodCount;
			}
			return 7 - doublePeriodCount;
	}
	NSLog(@"ERROR!!!");
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section != 2) {
		if (indexPath.section == 0 && indexPath.row == 1) {
			if ([UIScreen mainScreen].bounds.size.height == 568.0) {
				return 144.0;
			} else {
				return 104.0;
			}
		}
		return 44.0;
	}
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

- (int)numberOfConsecutivePeriodsAtPeriodIndex:(int)idx {
	return ((NSNumber *)[tableViewIndexToHeightMap objectForKey:[NSNumber numberWithInt:idx]]).integerValue + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	if (indexPath.section == 1) {
		static NSString *CellIdentifier = @"hdHomeworkEditViewControllerCell";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		}
	} else if (indexPath.section == 2) {
		static NSString *CellIdentifier = @"hdHomeworkEditViewControllerCellCheckbox";
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
	}
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0: {
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
					cell.accessoryType = UITableViewCellStyleDefault;
					CGRect textRect = CGRectMake(10, 10, [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 462 : 280, 30);
					nameTextField = [[UITextField alloc] initWithFrame:textRect];
					nameTextField.placeholder = @"Name";
					nameTextField.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
					nameTextField.text = self.homeworkTask.name;
					[cell.contentView addSubview:nameTextField];
					break;
				}
				case 1:
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test2"];
					cell.accessoryType = UITableViewCellStyleDefault;
					CGRect textRect = CGRectMake(2, 2, [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 475 : 296, [UIScreen mainScreen].bounds.size.height == 568.0 ? 140 : 100);
					detailsTextView = [[UITextView alloc] initWithFrame:textRect];
					detailsTextView.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
					detailsTextView.font = [UIFont fontWithName:@"Arial" size:17];
					detailsTextView.backgroundColor = [UIColor clearColor];
					detailsTextView.text = self.homeworkTask.details;
					[cell.contentView addSubview:detailsTextView];
					break;
			}
			break;
		case 1:
			cell.textLabel.text = @"Date due";
			cell.detailTextLabel.text = [hdHomeworkEditViewController formatDate:self.homeworkTask.date];
			break;
		case 2:
			nothing();
			BOOL foundCorrectPeriod = NO;
			if (indexPath.row == 0) {
				cell.textLabel.text = @"All day";
				cell.detailTextLabel.text = @"";
				if (_homeworkTask.period == 0) {
					foundCorrectPeriod = YES;
				}
			} else {
				cell.textLabel.text = [hdTimetableParser getSubjectForDay:self.homeworkTask.date
																													 period:((NSNumber *)([tableViewIndexToDoublePeriodOffsetMap objectForKey:
																																	 [NSNumber numberWithInt:indexPath.row]])).integerValue];
				int numberOfConsecutivePeriods = [self numberOfConsecutivePeriodsAtPeriodIndex:indexPath.row];
				if (numberOfConsecutivePeriods == 6) {
					cell.detailTextLabel.text = @"All day";
					foundCorrectPeriod = YES;
				} else if (numberOfConsecutivePeriods == 1) {
					int period = ((NSNumber *)[tableViewIndexToDoublePeriodOffsetMap objectForKey:
																		 [NSNumber numberWithInt:indexPath.row + 1]]).integerValue;
					if (period == 0) {
						period = 6;
					}
					cell.detailTextLabel.text = [NSString stringWithFormat:@"Period %i", period];
					if (_homeworkTask.period == period) {
						foundCorrectPeriod = YES;
					}
				} else if (numberOfConsecutivePeriods == 0) {
					
				} else {
					int period = ((NSNumber *)[tableViewIndexToDoublePeriodOffsetMap objectForKey:
																		 [NSNumber numberWithInt:indexPath.row]]).integerValue + 1;
					if (_homeworkTask.period == period) {
						foundCorrectPeriod = YES;
					}
					NSMutableString *subtitle = [[NSMutableString alloc] initWithFormat:@"%i", period];
					for (int i = 1; i < numberOfConsecutivePeriods; ++i) {
						period = ((NSNumber *)[tableViewIndexToDoublePeriodOffsetMap objectForKey:
																	 [NSNumber numberWithInt:indexPath.row + i - 1]]).integerValue + i + 1;
						if (_homeworkTask.period == period) {
							foundCorrectPeriod = YES;
						}
						[subtitle appendFormat:@" & %i", period];
					}
					cell.detailTextLabel.text = [NSString stringWithFormat:@"Periods %@", subtitle];
				}
			}
			if (foundCorrectPeriod) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				selectedCell = cell;
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
		if (indexPath.section == 1) {
			// Edit date
			hdHomeworkDatePickerViewController *dpvc = [self.storyboard instantiateViewControllerWithIdentifier:@"hdHomeworkDatePickerViewController"];
			dpvc.editViewController = self;
			dpvc.dateToDisplay = _homeworkTask.date;
			popover = [[UIPopoverController alloc] initWithContentViewController:dpvc];
			[popover presentPopoverFromRect:[self.tableView cellForRowAtIndexPath:indexPath].frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}
	if (selectedCell) {
		selectedCell.accessoryType = UITableViewCellAccessoryNone;
	}
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	selectedCell = cell;
    if (indexPath.row == 0) {
        _homeworkTask.period = 0;
    } else {
        _homeworkTask.period = ((NSNumber *)([tableViewIndexToDoublePeriodOffsetMap objectForKey:
                                              [NSNumber numberWithInt:indexPath.row]])).integerValue + 1;
    }
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