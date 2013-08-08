//
//  hdHomeworkDetailViewController.m
//  hDubNative
//
//  Created by printfn on 3/03/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkDetailViewController.h"
#import "hdDateUtils.h"
#import "hdHomeworkViewController.h"
#import "hdHomeworkEditViewController.h"

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
	self.title = [NSString stringWithFormat:@"%@ Homework", homeworkTask.period == 0 ? @"All Day" : homeworkTask.subject];
	[self.tableView reloadData];
}

// Called when user is finished editing a homework task, just before view returns to this view
- (void)updateHomeworkTask:(hdHomeworkTask *)ht {
	self.updated = YES;
	self.homeworkTask = ht;
    self.homeworkTask.subject = [hdTimetableParser getSubjectForDay:self.homeworkTask.date period:self.homeworkTask.period - 1];
    self.homeworkTask.room = [hdTimetableParser getRoomForDay:self.homeworkTask.date period:self.homeworkTask.period - 1];
    self.homeworkTask.teacher = [hdTimetableParser getTeacherForDay:self.homeworkTask.date period:self.homeworkTask.period - 1];
    [self.tableView reloadData];
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

// Called when transitioning to hdHomeworkEditViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"hdHomeworkEditViewControllerSegueFromDetailView"]) {
		hdHomeworkEditViewController *editViewController;
		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
			UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
			editViewController = (hdHomeworkEditViewController *)navigationController.topViewController;
		} else {
			editViewController = (hdHomeworkEditViewController *)segue.destinationViewController;
		}
		editViewController.homeworkTask = [self.homeworkTask copy];
		editViewController.previousViewController = self;
		editViewController.newHomeworkTask = NO;
	}
}

// User dismissed hdHomeworkDetailViewController
- (IBAction)done:(id)sender {
	if (self.updated == YES) {
		[((hdHomeworkViewController *)self.homeworkViewController) setHomeworkTask:self.homeworkTask inSection:self.section row:self.dayIndex];
		self.updated = NO;
	}
	[homeworkViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteHomeworkTask:(id)sender {
	self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete homework task?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
	[self.actionSheet showFromRect:self.deleteButton.frame inView:self.view animated:YES];
}

// Action sheet containing only the delete button: homework task has been deleted
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[(hdHomeworkViewController *)homeworkViewController deleteHomeworkTaskWithSection:self.section dayIndex:self.dayIndex];
		[homeworkViewController dismissViewControllerAnimated:YES completion:nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        noDetailsLabel.frame = CGRectMake(232, 323, 76, 21);
        homeworkDetailTextView.frame = CGRectMake(55, 299, 415, 186);
		if (homeworkTask.period == 0) {
			homeworkDetailTextView.frame = CGRectMake(homeworkDetailTextView.frame.origin.x,
                                                      homeworkDetailTextView.frame.origin.y - 44,
                                                      homeworkDetailTextView.frame.size.width,
                                                      homeworkDetailTextView.frame.size.height);
			noDetailsLabel.frame = CGRectMake(noDetailsLabel.frame.origin.x,
                                              noDetailsLabel.frame.origin.y - 44,
                                              noDetailsLabel.frame.size.width,
                                              noDetailsLabel.frame.size.height);
		}
		if (homeworkTask.room.length == 0) {
			homeworkDetailTextView.frame = CGRectMake(homeworkDetailTextView.frame.origin.x,
                                                      homeworkDetailTextView.frame.origin.y - 44,
                                                      homeworkDetailTextView.frame.size.width,
                                                      homeworkDetailTextView.frame.size.height);
			noDetailsLabel.frame = CGRectMake(noDetailsLabel.frame.origin.x,
                                              noDetailsLabel.frame.origin.y - 44,
                                              noDetailsLabel.frame.size.width,
                                              noDetailsLabel.frame.size.height);
		}
	} else {
        noDetailsLabel.frame = CGRectMake(20, 167, 280, 21);
        homeworkDetailTextView.frame = CGRectMake(20, 167, 280, 174);
    }
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		if (homeworkTask.period == 0) {
			return 2;
		}
		if (homeworkTask.room.length == 0) {
			return 3;
		} else {
			return 4;
		}
	} else {
		return 2;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"hdHomeworkDetailViewControllerCell";
	UITableViewCell *cell = [homeworkDataTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"hdHomeworkDetailViewControllerCell"];
	}
	
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Subject";
		if (homeworkTask.period == 0)
			cell.detailTextLabel.text = @"All day";
		else
			cell.detailTextLabel.text = homeworkTask.subject;
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Due";
		if (homeworkTask.period == 0)
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [hdDateUtils formatDate:homeworkTask.date]];
		else
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Period %i, %@", homeworkTask.period, [hdDateUtils formatDate:homeworkTask.date]];
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Teacher";
		cell.detailTextLabel.text = homeworkTask.teacher;
	} else if (indexPath.row == 3) {
		cell.textLabel.text = @"Room";
		cell.detailTextLabel.text = homeworkTask.room;
	}

	
	return cell;
}

@end
