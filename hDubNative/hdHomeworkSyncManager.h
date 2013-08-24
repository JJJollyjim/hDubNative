//
//  hdHomeworkSyncManager.h
//  hDubNative
//
//  Created by printfn on 5/05/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hdDataStore.h"

@class hdHomeworkTask, hdHomeworkDataStore;

@interface hdHomeworkSyncManager : NSObject {
    hdDataStore *sharedStore;
    NSMutableArray *unsyncedChanges;
    hdHomeworkDataStore *homeworkDataStore;
}

+ (hdHomeworkSyncManager *)sharedInstance;

- (void)deleteHomeworkTask:(hdHomeworkTask *)homeworkTask;
- (void)syncAndPullChanges;

@property (nonatomic) NSTimer *timer;

@end
