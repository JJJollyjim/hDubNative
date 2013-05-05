//
//  hdHomeworkSyncManager.m
//  hDubNative
//
//  Created by Jamie McClymont on 5/05/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdHomeworkSyncManager.h"
#import "hdDataStore.h"
#import "hdJsonWrapper.h"
#import "hdHomeworkTask.h"
#import "hdApiWrapper.h"

/*
 
 Dictionary, indexes starting at 1
 
 Deleting homework:
 {"type":"del", "hwid":uuid}
 
 Adding homework:
 {"type":"add", "hwid":uuid, "date":"2013-05-31", "period":1, "name":"English homework", "details":""}
 
 */

@implementation hdHomeworkSyncManager

- (id)init {
    self = [super init];
    if (self) {
        sharedStore = [hdDataStore sharedStore];
        unsyncedChanges = [hdJsonWrapper getObj:sharedStore.unsyncedEvents];
        if (!unsyncedChanges || unsyncedChanges.class != [NSMutableArray class]) {
            unsyncedChanges = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)syncAndPullChanges {
    NSMutableString *events = [[NSMutableString alloc] initWithString:@"{"];
    int i = 1;
    for (NSString *s in unsyncedChanges) {
        if (i != 1)
            [events appendFormat:@","];
        [events appendFormat:@"\"%i\":\"%@\"", i, s];
        ++i;
    }
    [events appendFormat:@"}"];
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
                          
                      }];
}

- (void)applyChange:(NSDictionary *)change {
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
    [unsyncedChanges addObject:[NSString stringWithFormat:@"{\"type\":\"del\", \"hwid\":\"%@\"", hwid]];
    NSLog(@"%@", unsyncedChanges);
    [self saveChanges];
}

@end
