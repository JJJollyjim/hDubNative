//
//  hdHomeworkSyncManager.h
//  hDubNative
//
//  Created by printfn on 5/05/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hdDataStore.h"

@class hdHomeworkTask;

@interface hdHomeworkSyncManager : NSObject {
    hdDataStore *sharedStore;
    NSMutableArray *unsyncedChanges;
}

- (void)deleteHomeworkTask:(hdHomeworkTask *)homeworkTask;
- (void)syncAndPullChanges;

@end
