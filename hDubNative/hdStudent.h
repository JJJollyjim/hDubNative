//
//  hdStudent.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hdDataStore.h"

@interface hdStudent : NSObject {
	int _uid, _pass;
	hdDataStore *_store;
	NSString *_homework, *_timetable;
}

- (void)loginNewUser:(int)sid
						password:(int)pass
						callback:(void (^) (BOOL, NSString *))callback;

@end