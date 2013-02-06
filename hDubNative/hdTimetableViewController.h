//
//  hdFirstViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdTimetableDataSource.h"

@interface hdTimetableViewController : UIViewController {
	hdTimetableDataSource *dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *timetableTableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *titleNavigationBar;

@end
