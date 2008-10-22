//
//  DoughAppDelegate.m
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import "DoughAppDelegate.h"
#import "RootViewController.h"

@implementation DoughAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	id toPost = [defaults objectForKey:@"entriesToPost"];
	
	if (toPost && [toPost isKindOfClass:[NSArray class]])
	{
		NSLog(@"Got dict we must post! %@", toPost);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNeedToSaveNotification object:self];
		
		[defaults removeObjectForKey:@"entriesToPost"];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNeedToSaveNotification object:self];
}

- (void)dealloc {
	[rootViewController release];
	[window release];
	[super dealloc];
}

@end
