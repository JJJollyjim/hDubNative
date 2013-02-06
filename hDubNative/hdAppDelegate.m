//
//  hdAppDelegate.m
//  hDubNative
//
//  Created by Jamie McClymont on 4/02/13.
//  Copyright (c) 2013 Kwiius. All rights reserved.
//

#import "hdAppDelegate.h"

#import "hdTimetableViewController.h"
#import "hdHomeworkViewController.h"
#import "hdSettingsViewController.h"
#import "hdHTTPWrapper.h"
#import "hdTimetable.h"

@implementation hdAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	/*hdHTTPWrapper *wrapper = [[hdHTTPWrapper alloc] init];
	
	[wrapper downloadFullHomeworkForUser:9079
															password:9391
															 success:^void (NSString *response) {
																 NSLog(@"Response: %@", response);
															 }
																 error:^void (NSString *errorMsg) {
																	 NSLog(@"Error Callback! %@", errorMsg);
																 }];*/
	
	 hdTimetable *timetable = [[hdTimetable alloc] initWithStudentId:9079
																													andPassword:9391
																													 success:^void (NSString *response) {
																														 NSLog(@"Response: %@", response);
																													 }
																														 error:^void (NSString *errorMsg) {
																															 NSLog(@"Error Callback! %@", errorMsg);
																														 }];
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	UIViewController *viewControllerTimetable, *viewControllerHomework, *viewControllerSettings;

  viewControllerTimetable = [[hdTimetableViewController alloc] initWithNibName:@"hdTimetableViewController" bundle:nil];
  viewControllerHomework = [[hdHomeworkViewController alloc] initWithNibName:@"hdHomeworkViewController" bundle:nil];
  viewControllerSettings = [[hdSettingsViewController alloc] initWithNibName:@"hdSettingsViewController" bundle:nil];
	
	self.tabBarController = [[UITabBarController alloc] init];
	self.tabBarController.viewControllers = @[viewControllerTimetable, viewControllerHomework, viewControllerSettings];
	self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
