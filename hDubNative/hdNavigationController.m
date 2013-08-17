//
//  hdNavigationController.m
//  hDubNative
//
//  Created by printfn on 8/17/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdNavigationController.h"

@implementation hdNavigationController

/*
 I have to subclass UINavigationController because this method can only be overridden by the view controller that is shown modally. This was the most annoying bug ever. Finally, it's fixed.
 */

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

@end
