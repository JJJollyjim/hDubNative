//
//  hdGeneralUtilities.m
//  hDubNative
//
//  Created by printfn on 8/29/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdGeneralUtilities.h"

@implementation hdGeneralUtilities

+ (NSString *)currentVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

@end
