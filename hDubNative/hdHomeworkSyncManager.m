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
        if (!unsyncedChanges || unsyncedChanges.class != [NSMutableArray class]) {
            unsyncedChanges = [[NSMutableArray alloc] init];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:60
                                                 target:self
                                               selector:@selector(timerCallback:)
                                               userInfo:NULL
                                                repeats:YES];
    }
    return self;
}

- (void)timerCallback:(NSTimer *)timer {
    //[self syncAndPullChanges];
}

- (void)syncAndPullChanges {
    return;
    NSLog(@"Syncing…");
    NSMutableString *events = [[NSMutableString alloc] initWithString:@"{"];
    int i = 1;
    for (NSString *s in unsyncedChanges) {
        if (i != 1)
            [events appendFormat:@","];
        [events appendFormat:@"\"%i\":%@", i, s];
        ++i;
    }
    [events appendFormat:@"}"];
    NSLog(@"Changes to upload: %@", events);
    //sharedStore.higheid = 60;
    [hdApiWrapper syncWithUser:sharedStore.userId
                      password:sharedStore.pass
                       higheid:sharedStore.higheid
                        events:events
                      callback:^(BOOL success, NSString *errorMsg, NSString *errorReport) {
                          if (!success) {
                              NSLog(@"Sync error: %@ (%@)", errorMsg, errorReport);
                          }
                          NSString *response = errorMsg;
                          NSDictionary *result = [hdJsonWrapper getObj:response];
                          sharedStore.higheid = [[result objectForKey:@"new_high_eid"] integerValue];
                          
                          NSDictionary *newEvents = [result objectForKey:@"new_events"];
                          
                          int newEventsIndex = 1; // because Jamie is weird
                          int newEventsCount = [newEvents count]+1;
                          
                          NSLog(@"Changes downloaded: ");
                          
                          while (newEventsIndex < newEventsCount) {
                              NSDictionary *change = [newEvents valueForKey:[NSString stringWithFormat:@"%i", newEventsIndex]];
                              NSLog(@"%i: %@", newEventsIndex, change);
                              [self applyServerChange:change];
                              newEventsIndex++;
                          }
                          NSLog(@"Finished sync!");
                      }];
}

- (void)applyServerChange:(NSDictionary *)change {
    if ([[change objectForKey:@"type"] isEqualToString:@"add"]) {
        
    } else if ([[change objectForKey:@"type"] isEqualToString:@"del"]) {
        
    }
}

- (void)saveChanges {
    sharedStore.unsyncedEvents = [hdJsonWrapper getJson:unsyncedChanges];
}

- (void)deleteHomeworkTask:(hdHomeworkTask *)homeworkTask {
    NSString *hwid = homeworkTask.hwid;
    if (!hwid)
        hwid = [hdHomeworkTask generateUUID];
    [unsyncedChanges addObject:[NSString stringWithFormat:@"{\"type\":\"del\", \"hwid\":\"%@\"}", hwid]];
    NSLog(@"%@", unsyncedChanges);
    [self saveChanges];
    [self syncAndPullChanges];
}

@end
