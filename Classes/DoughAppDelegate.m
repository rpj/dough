//
//  DoughAppDelegate.m
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Ryan Joseph, 2008. All rights reserved.
//

#import "DoughAppDelegate.h"
#import "RootViewController.h"
#import "WebConnection.h"
#import "NSString+Utils.h"

@implementation DoughAppDelegate

@synthesize window;
@synthesize rootViewController;

- (void) webConnEnded:(WebConnection*)wConn withError:(NSError*)error;
{
	if (error)
	{
		NSLog(@"There was a registration error:\n%@", error);
	}
	else
	{
		NSLog(@"Found or set valid registration.");
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDoughDeviceRegisteredDefaultsKey];
	}
}

- (void) checkForAndRegisterDevice;
{	
	[WebConnection sendDoughRequest:[NSString stringWithFormat:@"act=nu&phid=%@", [DoughAppDelegate deviceSHA1]] 
						endSelector:@selector(webConnEnded:withError:)
					   targetObject:self];
}

//////


+ (NSString*) deviceSHA1;
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	static NSString* retVal = nil;
	
	if (!retVal && ![defaults objectForKey:@"sha_uid"])
	{
		NSString* uid = [[[UIDevice currentDevice] uniqueIdentifier] SHA1AsHex];
		if (uid) [defaults setObject:(retVal = uid) forKey:@"sha_uid"];
	}
	else
		retVal = [defaults objectForKey:@"sha_uid"];
	
	return retVal;
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[window addSubview:[rootViewController view]];
	[window makeKeyAndVisible];
	
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	
	// ensure the user defaults has a SHA-1'ed version of the device's ID stored
	[DoughAppDelegate deviceSHA1];
	
	/// check to see if there is any outstanding info to post
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	id toPost = [defaults objectForKey:kDoughEntriesDefaultsKey];
	
	if (![defaults boolForKey:kDoughDeviceRegisteredDefaultsKey])
		[self checkForAndRegisterDevice];
	
	if (toPost && [toPost isKindOfClass:[NSArray class]])
	{
		NSLog(@"On startup, found %d entries needing to be posted.", [toPost count]);
		[[NSNotificationCenter defaultCenter] postNotificationName:kNeedToSaveNotification object:self];
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
