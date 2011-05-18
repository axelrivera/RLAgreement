//
//  RLAgreementAppDelegate.m
//  RLAgreement
//
//  Created by Axel Rivera on 5/16/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "RLAgreementAppDelegate.h"
#import "RootViewController.h"
#import "RLAgreementViewController.h"

@implementation RLAgreementAppDelegate

@synthesize window = _window;

@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Override point for customization after application launch.
	 
	self.window.rootViewController = self.viewController;
	[self.window makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{	
	// Check the value of the Agreement Identifier in NSUserDefaults
	// and call the RLAgreementViewController if the user hasn't accepted the terms.
	BOOL validAgreement = [[NSUserDefaults standardUserDefaults] boolForKey:kRLAgreementIdentifier];
	if (!validAgreement) {
		RLAgreementViewController *agreementController = [[RLAgreementViewController alloc] init];
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:agreementController];
		
		[agreementController release];
		
		[self.viewController presentModalViewController:navController animated:YES];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[_window release];
	[_viewController release];
    [super dealloc];
}

@end
