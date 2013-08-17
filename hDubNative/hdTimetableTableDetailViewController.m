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

@interface hdTimetableTableDetailViewController ()

@end

@implementation hdTimetableTableDetailViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        homeworkDataStore = [[hdHomeworkDataStore alloc] init];
        sharedStore = [hdDataStore sharedStore];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:135/255.0f
                                                                        green:10/255.0f
                                                                         blue:0.0f
                                                                        alpha:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1 + [homeworkDataStore sectionCountOfHomeworkTasksWithDate:self.date];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
