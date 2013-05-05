//
//  hdDataStore.h
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdDataStore : NSObject {
	NSUserDefaults *defaults;
}

+ (hdDataStore *)sharedStore;

- (void)synchronize;

- (BOOL)userLoggedIn;
- (void)setUserLoggedIn:(BOOL)userLoggedIn;

- (int)userId;
- (void)setUserId:(int)sid;

- (int)pass;
- (void)setPass:(int)pass;

- (NSString *)name;
- (void)setName:(NSString *)name;

- (NSString *)form;
- (void)setForm:(NSString *)form;

- (int)year;
- (void)setYear:(int)year;

- (int)higheid;
- (void)setHigheid:(int)eid;

- (NSString *)timetableJson;
- (void)setTimetableJson:(NSString *)json;

- (NSString *)homeworkJson;
- (void)setHomeworkJson:(NSString *)json;

- (NSString *)unsyncedEvents;
- (void)setUnsyncedEvents:(NSString *)e;

@end
