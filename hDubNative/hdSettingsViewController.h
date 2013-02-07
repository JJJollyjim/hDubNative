//
//  hdSettingsViewController.h
//  hDubNative
//
//  Created by Jamie McClymont on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hdDataStore.h"

@interface hdSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *sidLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logout:(id)sender;

@end
