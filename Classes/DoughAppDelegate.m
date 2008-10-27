//
//  DoughAppDelegate.m
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Ryan Joseph, 2008. All rights reserved.
//

#import "DoughAppDelegate.h"
#import "RootViewController.h"

#import "NSString+Utils.h"

@implementation DoughAppDelegate

@synthesize window;
@synthesize rootViewController;

//////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	_tempLoadData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_tempLoadData) [_tempLoadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	if (![_tempLoadData length])
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDoughDeviceRegisteredDefaultsKey];
	else
	{
		NSString* strData = [[NSString alloc] initWithBytes:[_tempLoadData bytes] 
													 length:[_tempLoadData length] 
												   encoding:NSUTF8StringEncoding];
		
		NSLog(@"Registration error: %@", strData);
		[strData release];
	}
	
	[_tempLoadData release];
	_tempLoadData = nil;
}

- (void) checkForAndRegisterDevice;
{	
	NSString* reqBody = [NSString stringWithFormat:@"act=nu&phid=%@", [DoughAppDelegate deviceSHA1]];
	NSMutableURLRequest* urlReq = [NSMutableURLRequest requestWithURL:
								   [NSURL URLWithString:@"http://24.130.91.57/cgi-bin/doughTest.cgi"]];
	
	[urlReq setHTTPMethod:@"POST"];
	[urlReq setHTTPShouldHandleCookies:NO];
	[urlReq setHTTPBody:[NSData dataWithBytes:[reqBody cStringUsingEncoding:NSASCIIStringEncoding]
									   length:[reqBody lengthOfBytesUsingEncoding:NSASCIIStringEncoding]]];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[NSURLConnection connectionWithRequest:urlReq delegate:self];
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
