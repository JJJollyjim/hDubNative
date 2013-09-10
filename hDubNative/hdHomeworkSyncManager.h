//
//  hdHomeworkSyncManager.h
//  hDubNative
//
//  Created by Jamie McClymont on 5/05/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "hdDataStore.h"

@class hdHomeworkTask, hdHomeworkDataStore;

@interface hdHomeworkSyncManager : NSObject {
    hdDataStore *sharedStore;
    NSMutableArray *unsyncedChanges;
    hdHomeworkDataStore *homeworkDataStore;
    BOOL currentlySyncing;
}

+ (hdHomeworkSyncManager *)sharedInstance;

- (void)deleteHomeworkTask:(NSString *)hwid;
- (void)addHomeworkTask:(hdHomeworkTask *)hwtask;
- (void)syncAndPullChanges;

- (void)stopTimer;
- (void)startTimer;

@property (nonatomic) NSTimer *timer;

@end
