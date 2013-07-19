//
//  NHAppDelegate.m
//  NHSlidingControllerDemo
//
//  Created by Nils Hayat on 7/19/13.
//  Copyright (c) 2013 Nils Hayat. All rights reserved.
//

#import "NHAppDelegate.h"
#import "NHSlidingController.h"

@implementation NHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
	
	UIViewController *topViewController = [[UIViewController alloc] init];
	topViewController.view.backgroundColor = [UIColor blueColor];
	UIViewController *bottomViewController = [[UIViewController alloc] init];
	bottomViewController.view.backgroundColor = [UIColor redColor];
	
	NHSlidingController *slidingController = [[NHSlidingController alloc] initWithTopViewController:topViewController bottomViewController:bottomViewController];
	slidingController.slideDistance = 280.0;
	
	self.window.rootViewController = slidingController;
	
    [self.window makeKeyAndVisible];
    return YES;
}

@end
