//
//  hdStudent.h
//  hDubNative
//
//  Created by printfn on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@class hdDataStore;

@interface hdStudent : NSObject {
	hdDataStore *_store;
	NSString *timetableJson;
}

+ (hdStudent *)sharedStudent;

- (void)loginUser:(int)sid
						password:(int)pass
						callback:(void (^) (BOOL, NSString *, NSString *))callback;

@end