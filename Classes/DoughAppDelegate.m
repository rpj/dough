//
//  DoughAppDelegate.m
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import "DoughAppDelegate.h"
#import "RootViewController.h"

#include <CommonCrypto/CommonDigest.h>

@implementation DoughAppDelegate

@synthesize window;
@synthesize rootViewController;

+ (NSString*) deviceSHA1;
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSString* retVal = nil;
	
	if (![defaults objectForKey:@"sha_uid"])
	{
		NSString* uid = [[UIDevice currentDevice] uniqueIdentifier];
		
		unsigned char* sha1out = (unsigned char*)malloc(CC_SHA1_DIGEST_LENGTH);
		sha1out = CC_SHA1((const void*)[uid cStringUsingEncoding:NSASCIIStringEncoding],
						  (CC_LONG)[uid lengthOfBytesUsingEncoding:NSASCIIStringEncoding],
						  sha1out);
		
		NSMutableString* shauid = [NSMutableString string];
		uint8_t count = 0;
		for (; count < CC_SHA1_DIGEST_LENGTH; sha1out++, count++)
		{
			[shauid appendFormat:@"%x", *sha1out];
		}
		
		[defaults setObject:shauid forKey:@"sha_uid"];
		retVal = shauid;
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
	id toPost = [defaults objectForKey:@"entriesToPost"];
	
	if (toPost && [toPost isKindOfClass:[NSArray class]])
	{
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
