//
//  hdJsonWrapper.m
//  hDubNative
//
//  Created by Jamie McClymont on 5/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdJsonWrapper.h"

@implementation hdJsonWrapper

+ (NSString *)getJson:(id)object {
	NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)getObj:(NSString *)json {
	NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
    if (data == nil) {
        [NSException raise:@"JSON: Data is nil" format:@"[hdJsonWrapper getObj]: data is nil"];
    }
	id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:0
                                               error:&error];
	return obj;
}

@end
