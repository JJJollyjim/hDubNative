//
//  hdTimetableDataSource.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hdDataStore.h"

@interface hdTimetableDataSource : NSObject <UITableViewDataSource> {
	hdDataStore *sharedStore;
	NSDictionary *timetableRootObject;
}

@end
