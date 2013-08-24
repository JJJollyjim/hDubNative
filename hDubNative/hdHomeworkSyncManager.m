//
//  hdHomeworkSyncManager.m
//  hDubNative
//
//  Created by printfn on 5/05/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkSyncManager.h"
#import "hdDataStore.h"
#import "hdJsonWrapper.h"
#import "hdHomeworkTask.h"
#import "hdApiWrapper.h"
#import "hdHomeworkDataStore.h"

#define TIMER_INTERVAL 20

/*
 
 Dictionary, indexes starting at 1
 
 Deleting homework:
 {"type":"del", "hwid":uuid}
 
 Adding homework:
 {"type":"add", "hwid":uuid, "date":"2013-05-31", "period":1, "name":"English homework", "details":""}
 
*/

@implementation hdHomeworkSyncManager

@synthesize timer;

+ (hdHomeworkSyncManager *)sharedInstance {
	static hdHomeworkSyncManager *sharedInstance = nil;
	if (!sharedInstance) {
		sharedInstance = [[hdHomeworkSyncManager alloc] init];
	}
	return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        sharedStore = [hdDataStore sharedStore];
        unsyncedChanges = [hdJsonWrapper getObj:sharedStore.unsyncedEvents];
        if (!unsyncedChanges) {
            unsyncedChanges = [[NSMutableArray alloc] init];
        } else {
            unsyncedChanges = [NSMutableArray arrayWithArray:unsyncedChanges];
        }
        currentlySyncing = NO;
        [self startTimer];
    }
    return self;
}

- (void)timerCallback:(NSTimer *)timer {
    [self syncAndPullChanges];
}

- (void)syncAndPullChanges {
    if (currentlySyncing)
        return;
    currentlySyncing = YES;
    NSMutableString *events = [[NSMutableString alloc] initWithString:@"{"];
    int i = 1;
    for (NSString *s in unsyncedChanges) {
        if (i != 1)
            [events appendFormat:@","];
        [events appendFormat:@"\"%i\":%@", i, s];
        ++i;
    }
    [events appendFormat:@"}"];
    if (![events isEqualToString:@"{}"])
        NSLog(@"Changes to upload: %@", events);
    [hdApiWrapper syncWithUser:sharedStore.userId
                      password:sharedStore.pass
                       higheid:sharedStore.higheid
                        events:events
                      callback:^(BOOL success, NSString *errorMsg, NSString *errorReport) {
                          if (!success) {
                              NSLog(@"Sync error: %@ (%@)", errorMsg, errorReport);
                              currentlySyncing = NO;
                              return;
                          }
                          [unsyncedChanges removeAllObjects];
                          
                          NSString *response = errorMsg;
                          NSDictionary *result = [hdJsonWrapper getObj:response];
                          sharedStore.higheid = [[result objectForKey:@"new_high_eid"] integerValue];
                          
                          NSDictionary *newEvents = [result objectForKey:@"new_events"];
                          
                          int newEventsIndex = 1;
                          int newEventsCount = [newEvents count]+1;
                          
                          if ([newEvents count] != 0)
                              NSLog(@"Changes downloaded: ");
                          
                          while (newEventsIndex < newEventsCount) {
                              NSDictionary *change = [newEvents valueForKey:[NSString stringWithFormat:@"%i", newEventsIndex]];
                              NSLog(@"%i: %@", newEventsIndex, change);
                              [self applyServerChange:change];
                              newEventsIndex++;
                          }
                          currentlySyncing = NO;
                      }];
}

- (void)applyServerChange:(NSDictionary *)change {
    if ([[change objectForKey:@"type"] isEqualToString:@"add"]) {
        hdHomeworkTask *hwtask = [[hdHomeworkTask alloc] init];
        hwtask.date = [change objectForKey:@"date"];
        hwtask.period = [[change objectForKey:@"period"] integerValue];
        hwtask.hwid = [change objectForKey:@"hwid"];
        hwtask.name = [change objectForKey:@"name"];
        hwtask.details = [change objectForKey:@"details"];
        [[hdHomeworkDataStore sharedStore] addHomeworkTask:hwtask]; // adds change to unsyncedEvents array, which will be removed  |
        [unsyncedChanges removeLastObject];                         //                                       <---------------------+
    } else if ([[change objectForKey:@"type"] isEqualToString:@"del"]) {
        [[hdHomeworkDataStore sharedStore] deleteHomeworkTaskWithId:[change objectForKey:@"hwid"]];
        [unsyncedChanges removeLastObject]; // prev. line added a sync task, has to be removed here
    }
}

- (void)saveChanges {
    sharedStore.unsyncedEvents = [hdJsonWrapper getJson:unsyncedChanges];
}

// User deleted homework task
- (void)deleteHomeworkTask:(NSString *)hwid {
    if (!hwid)
        return;
    [unsyncedChanges addObject:[NSString stringWithFormat:@"{\"type\":\"del\", \"hwid\":\"%@\"}", hwid]];
    //NSLog(@"%@", unsyncedChanges);
    [self saveChanges];
}

// User adds hwtask
- (void)addHomeworkTask:(hdHomeworkTask *)hwtask {
    if (!hwtask)
        return;
    [unsyncedChanges addObject:[NSString stringWithFormat:
                                @"{\"type\":\"add\", \"hwid\":\"%@\", \"date\":\"%@\", \"period\":\"%i\", \"name\":\"%@\", \"details\":\"%@\"}",
                                hwtask.hwid, hwtask.date, hwtask.period, hwtask.name, hwtask.details]];
    [self saveChanges];
}

- (void)stopTimer {
    NSLog(@"stopTimer");
    [timer invalidate];
    timer = nil;
}

- (void)startTimer {
    NSLog(@"startTimer");
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL
                                                 target:self
                                               selector:@selector(timerCallback:)
                                               userInfo:NULL
                                                repeats:YES];
    }
}

@end
