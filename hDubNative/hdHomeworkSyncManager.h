//
//  hdHomeworkSyncManager.h
//  hDubNative
//
//  Created by Jamie McClymont on 5/05/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hdDataStore.h"

@interface hdHomeworkSyncManager : NSObject {
    hdDataStore *sharedStore;
    NSMutableArray *unsyncedChanges;
}

@end
