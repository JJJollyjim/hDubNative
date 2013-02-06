//
//  hdTimetableDataSource.m
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdTimetableDataSource.h"
#import "hdStudent.h"
#import "hdJsonWrapper.h"
#import "hdTimetableParser.h"

@implementation hdTimetableDataSource

/*
 
 {
     "2012-11-15":{
		     "1":{
             "name":"13EGA"
         },
		     "2":{
             "name":"13HI"
         }, ...
     }, ...
 }
 
 */

- (id)init {
	self = [super init];
	
	sharedStore = [hdDataStore sharedStore];
	timetableRootObject = [hdJsonWrapper getObj:sharedStore.timetableJson];
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
				 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *subject = [hdTimetableParser getSubjectForDay:[NSDate date] period:indexPath.row rootObj:timetableRootObject];
	
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	cell.textLabel.text = subject;
	
	return cell;
}

@end
