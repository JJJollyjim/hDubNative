//
//  hdTimetableTableDetailViewController.m
//  hDubNative
//
//  Created by printfn on 7/21/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

/* 
 Title: Classical Studies
 
 Section: Details
   Subject - Classical Studies
   Date - Thu 23 May
   Period - 6
   Teacher - Mr Adams (AMD)
   Room - P3C
 
 Section Homework Task 1:
   Title - Hi
   Description - Lol
 */
#import "hdTimetableTableDetailViewController.h"
#import "hdHomeworkDataStore.h"
#import "hdTimetableParser.h"
#import "hdDateUtils.h"
#import "hdHomeworkEditViewController.h"

@interface hdTimetableTableDetailViewController ()

@end

@implementation hdTimetableTableDetailViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    homeworkDataStore = [hdHomeworkDataStore sharedStore];
    sharedStore = [hdDataStore sharedStore];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:135/255.0f
                                                                        green:10/255.0f
                                                                         blue:0.0f
                                                                        alpha:1.0f];
    
    
    NSString *subject = [hdTimetableParser getSubjectForDay:[hdDateUtils jsonDateToDate:self.date] period:self.period];
    self.title = [NSString stringWithFormat:@"%@, Period %i", subject, self.period];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    UIViewController *previousViewController = self.timetableTableViewController;
    [previousViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"hdHomeworkEditViewControllerSegueFromTimetableDetailViewController"]) {
		// New homework task
		hdHomeworkEditViewController *editViewController;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
            editViewController = (hdHomeworkEditViewController *)navigationController.topViewController;
        } else {
            editViewController = (hdHomeworkEditViewController *)segue.destinationViewController;
        }
		editViewController.homeworkTask = [[hdHomeworkTask alloc] init];
		editViewController.previousViewController = self;
		editViewController.newHomeworkTask = YES;
        editViewController.homeworkDataStore = [hdHomeworkDataStore sharedStore];
        editViewController.homeworkTask.date = self.date;
        editViewController.homeworkTask.period = self.period;
    }
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    [homeworkDataStore initializeHomeworkDataStore]; // Reload is necessary because after adding a homework task the two instances of hdHomeworkDataStore are out of sync
    homeworkTasksOnDay = [homeworkDataStore homeworkTasksOnDay:self.date];
    NSMutableArray *homeworkTasksFilteredToCorrectPeriod = [NSMutableArray array];
    NSString *(^getSubjectForPeriod)(int) = ^(int period) {
        return [hdTimetableParser getSubjectForDay:[hdDateUtils jsonDateToDate:self.date] period:period];
    };
    for (hdHomeworkTask *hwtask in homeworkTasksOnDay) {
        if (hwtask.period == self.period) { // correct period
            [homeworkTasksFilteredToCorrectPeriod addObject:hwtask];
        } else if (hwtask.period == 0) { // all day homework task
            [homeworkTasksFilteredToCorrectPeriod addObject:hwtask];
        } else if ([getSubjectForPeriod(self.period) isEqualToString:getSubjectForPeriod(hwtask.period)]) {
            [homeworkTasksFilteredToCorrectPeriod addObject:hwtask];
        }
    }
    homeworkTasksOnDay = homeworkTasksFilteredToCorrectPeriod;
    return 1 + homeworkTasksOnDay.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        NSDate *nsDate = [hdDateUtils jsonDateToDate:self.date];
        NSString *room = [hdTimetableParser getRoomForDay:nsDate period:self.period];
        if (room.length == 0) { // probably a study period
            return 4;
        } else {
            return 5;
        }
    } else {
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Details";
    } else {
        if (((hdHomeworkTask *)[homeworkTasksOnDay objectAtIndex:section - 1]).period == 0) {
            return [NSString stringWithFormat:@"Homework Task %i (All day)", section]; // 1-n instead of 0-n
        } else {
            return [NSString stringWithFormat:@"Homework Task %i", section]; // 1-n instead of 0-n
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewCell"];
	}
    
    if (indexPath.section == 0) {
        /*
         Section: Details
           Subject - Classical Studies
           Date - Thu 23 May
           Period - 6
           Teacher - Mr Adams (AMD)
           Room - P3C
        */
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"Subject";
                cell.detailTextLabel.text = [hdTimetableParser getSubjectForDay:[hdDateUtils jsonDateToDate:self.date] period:self.period];
                break;
            }
            case 1: {
                cell.textLabel.text = @"Date";
                cell.detailTextLabel.text = [hdDateUtils formatDate:[hdDateUtils jsonDateToDate:self.date]];
                break;
            }
            case 2: {
                cell.textLabel.text = @"Period";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", self.period];
                break;
            }
            case 3: {
                cell.textLabel.text = @"Teacher";
                cell.detailTextLabel.text = [hdTimetableParser getTeacherForDay:[hdDateUtils jsonDateToDate:self.date] period:self.period];
                break;
            }
            case 4: {
                cell.textLabel.text = @"Room";
                cell.detailTextLabel.text = [hdTimetableParser getRoomForDay:[hdDateUtils jsonDateToDate:self.date] period:self.period];
                break;
            }
        }
    } else {
        // Show homework tasks
        // section 0: date details, section 1-n: hwtasks 0-(n-1)
        hdHomeworkTask *homeworkTask = [homeworkTasksOnDay objectAtIndex:indexPath.section - 1];
        if (indexPath.row == 0) {
            // Show name
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = homeworkTask.name;
        } else {
            // Details
            cell.textLabel.text = @"Details";
            cell.detailTextLabel.text = homeworkTask.details;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
