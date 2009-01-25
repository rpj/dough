//
//  SourDoughAppDelegate.m
//  SourDough
//
//  Created by Ryan Joseph on 11/11/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import "SourDoughAppDelegate.h"
#import "RootViewController.h"

@implementation SourDoughAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
