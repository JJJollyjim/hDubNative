//
//  hdApiWrapper.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdApiWrapper : NSObject

+ (void)loginWithSid:(int)sid
								pass:(int)pass
						callback:(void (^) (BOOL, NSString *, NSString *))callback;

+ (void)syncWithUser:(int)sid
            password:(int)pass
             higheid:(int)higheid
              events:(NSString *)events
            callback:(void (^) (BOOL, NSString *, NSString *))callback;

@end
