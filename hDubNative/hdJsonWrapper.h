//
//  hdJsonWrapper.h
//  hDubNative
//
//  Created by Jamie McClymont on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface hdJsonWrapper : NSObject

+ (NSString *)getJson:(id)object;
+ (id)getObj:(NSString *)json;

@end
