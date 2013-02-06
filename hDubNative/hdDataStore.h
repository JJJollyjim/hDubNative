//
//  hdDataStore.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdDataStore : NSObject {
	NSUserDefaults *defaults;
}

- (BOOL)userLoggedIn;
- (void)setUserLoggedIn:(BOOL)userLoggedIn;

- (int)userId;
- (void)setUserId:(int)sid;

- (int)pass;
- (void)setPass:(int)pass;

- (int)higheid;
- (void)setHigheid:(int)eid;

- (NSString *)timetableJson;
- (void)setTimetableJson:(NSString *)json;

- (NSString *)homeworkJson;
- (void)setHomeworkJson:(NSString *)json;

@end
