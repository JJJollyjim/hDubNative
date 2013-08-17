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
#import "hdTimetableParser.h"

@implementation hdHomeworkDetailViewController

@synthesize homeworkTask, homeworkTitle, homeworkDetailTextView, homeworkDataTableView, homeworkViewController, noDetailsLabel, homeworkDataStore;

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
	self.title = [hdTimetableParser getSubjectForDay:[hdDateUtils jsonDateToDate:homeworkTask.date] period:homeworkTask.period];
	[self.tableView reloadData];
}

// Called when user is finished editing a homework task, just before view returns to this view controller
- (void)updateHomeworkTask:(hdHomeworkTask *)ht {
	self.updated = YES;
	self.homeworkTask = ht;
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
        editViewController.homeworkDataStore = self.homeworkDataStore;
		editViewController.newHomeworkTask = NO;
	}
}

// User dismissed hdHomeworkDetailViewController
- (IBAction)done:(id)sender {
	if (self.updated == YES) {
		[homeworkDataStore updateHomeworkTaskWithId:self.homeworkTask.hwid withNewHomeworkTask:self.homeworkTask];
		self.updated = NO;
	}
	[homeworkViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteHomeworkTask:(id)sender {
	self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete homework task?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:@"Delete"
                                          otherButtonTitles:nil];
	[self.actionSheet showFromRect:self.deleteButton.frame inView:self.view animated:YES];
}

// Action sheet containing only the delete button:
//   homework task has been deleted
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[homeworkDataStore deleteHomeworkTaskAtIndexPath:[NSIndexPath indexPathForRow:self.row inSection:self.section]];
		[homeworkViewController dismissViewControllerAnimated:YES completion:nil];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *room = [hdTimetableParser getRoomForDay:[hdDateUtils jsonDateToDate:homeworkTask.date]
                                               period:homeworkTask.period];
    
    CGRect (^moveRect)(CGRect, int, int, int, int) = ^(CGRect r, int dx, int dy, int dw, int dh){
        return CGRectMake(r.origin.x+dx, r.origin.y+dy, r.size.width+dw, r.size.height+dh);
    };
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        homeworkDetailTextView.frame = CGRectMake(55, 299, 415, 186);
        noDetailsLabel.frame = CGRectMake(232, 323, 76, 21);
        if (homeworkTask.period == 0) {
            homeworkDetailTextView.frame = moveRect(homeworkDetailTextView.frame, 0, -44, 0, 0);
            noDetailsLabel.frame = moveRect(noDetailsLabel.frame, 0, -44, 0, 0);
        }
        if (room.length == 0) {
            homeworkDetailTextView.frame = moveRect(homeworkDetailTextView.frame, 0, -44, 0, 0);
            noDetailsLabel.frame = moveRect(noDetailsLabel.frame, 0, -44, 0, 0);
        }
	} else {
          homeworkDetailTextView.frame = CGRectMake(20, 260, 280, 82);
          noDetailsLabel.frame = CGRectMake(20, 260, 280, 21);
		if (homeworkTask.period == 0) {
            homeworkDetailTextView.frame = moveRect(homeworkDetailTextView.frame, 0, -44, 0, 44);
            noDetailsLabel.frame = moveRect(noDetailsLabel.frame, 0, -44, 0, 0);
        }
        if (room.length == 0) {
            homeworkDetailTextView.frame = moveRect(homeworkDetailTextView.frame, 0, -44, 0, 44);
            noDetailsLabel.frame = moveRect(noDetailsLabel.frame, 0, -44, 0, 0);
        }
    }
    
    if (homeworkTask.period == 0) {
        return 2;
    }
    if (room.length == 0) {
        return 3;
    } else {
        return 4;
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
			cell.detailTextLabel.text = [hdTimetableParser getSubjectForDay:[hdDateUtils jsonDateToDate:homeworkTask.date]
                                                                     period:homeworkTask.period];
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Due";
		if (homeworkTask.period == 0)
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [hdDateUtils formatDate:[hdDateUtils jsonDateToDate:homeworkTask.date]]];
		else
			cell.detailTextLabel.text = [NSString stringWithFormat:@"Period %i, %@", homeworkTask.period, [hdDateUtils formatDate:[hdDateUtils jsonDateToDate:homeworkTask.date]]];
	} else if (indexPath.row == 2) {
		cell.textLabel.text = @"Teacher";
		cell.detailTextLabel.text = [hdTimetableParser getTeacherForDay:[hdDateUtils jsonDateToDate:homeworkTask.date] period:homeworkTask.period];
	} else if (indexPath.row == 3) {
		cell.textLabel.text = @"Room";
		cell.detailTextLabel.text = [hdTimetableParser getRoomForDay:[hdDateUtils jsonDateToDate:homeworkTask.date] period:homeworkTask.period];
	}

	
	return cell;
}

@end
