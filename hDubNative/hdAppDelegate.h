//
//  hdAppDelegate.h
//  hDubNative
//
//  Created by printfn on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hdAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

@end
