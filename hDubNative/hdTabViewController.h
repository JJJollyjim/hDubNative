//
//  hdTabViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 6/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "hdLoginViewController.h"

@interface hdTabViewController : UITabBarController {
	hdLoginViewController *loginViewController;
}

- (void)presentLoginViewControllerIfRequired;
- (void)updateSubviews;

@end
