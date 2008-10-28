//
//  DataController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Ryan Joseph. All rights reserved.
//

#import "DataController.h"
#import "DoughAppDelegate.h"
#import "NSString+Utils.h"
#import "WebConnection.h"

#import <JSON/JSON.h>

#define kGoogleLocalURLQueryString		@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large&sll=%f,%f&q=%@"

@implementation DataController

@dynamic locationServicesEnabled;
@dynamic hasData;

@synthesize dataStore = _dataStore;
@synthesize latestLocation = _newestLoc;

- (BOOL) locationServicesEnabled;
{
	return _locMgr.locationServicesEnabled;
}

- (BOOL) hasData;
{
	return ([_dataStore count] != 0);
}

- (id) init;
{
	if ((self = [super init]))
	{
		_locMgr = [[CLLocationManager alloc] init];
		
		_locMgr.delegate = self;
		_locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		_locMgr.distanceFilter = 2.0;
		
		_newestLoc = nil;
		_canMakeRequest = YES;
		
		_dataStore = [[NSMutableArray alloc] init];
		
		NSNotificationCenter* cent = [NSNotificationCenter defaultCenter];
		[cent addObserver:self selector:@selector(sendEntries:) name:kSendToWebNowNotification object:nil];
		
		if (_locMgr.locationServicesEnabled)
		{
			[cent postNotificationName:kStartingToLocateNotification object:self];
			[_locMgr startUpdatingLocation];
		}
	}
	
	return self;
}

- (void) dealloc;
{
	[_locMgr release];
	_locMgr = nil;
	
	[_newestLoc release];
	[_dataStore release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:nil];
	
	[super dealloc];
}

- (BOOL) startLoadingLocalInfoWithQueryString:(NSString*)query;
{
	if (_newestLoc && _canMakeRequest)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:kStartingToLoadNotification object:self];
		[_dataStore removeAllObjects];
		
		CLLocationCoordinate2D coord = _newestLoc.coordinate;
		
		NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:kGoogleLocalURLQueryString, 
										   coord.latitude, coord.longitude, 
										   [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
		
		return YES;
	}
	
	return NO;
}

- (void) sendEntries:(id)arg;
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSArray* arr = [defaults objectForKey:kDoughEntriesDefaultsKey];
	NSString* uid = [DoughAppDelegate deviceSHA1];
	NSNotificationCenter* nCent = [NSNotificationCenter defaultCenter];
	
	if (arr && [arr count] && uid)
	{
		NSString* body = [arr JSONRepresentation];
		NSString* sha1 = [body SHA1AsHex];
		
		NSURLResponse* resp = nil;
		NSData* retData = [WebConnection sendSynchronousRequest:
						   [NSString stringWithFormat:@"act=ta&phid=%@&sha=%@&json=%@", uid, sha1, [body URLEncode]]
											  returningResponse:&resp
														  error:nil];
		
		if (retData)
		{
			if (![retData length])
			{
				[defaults removeObjectForKey:kDoughEntriesDefaultsKey];
				[nCent postNotificationName:kSaveWasSuccessfulNotification object:self];
			}
			else
			{
				NSLog(@"ERROR: \n%@\n", [NSString stringWithCString:[retData bytes] length:[retData length]]);
			}
		}
		else
		{
			NSLog(@"URL send was unsuccessful! Leaving object in defaults until next time...");
		}
	}
	
	[nCent postNotificationName:kSaveOperationEndedNotification object:self];
}

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
	if (manager == _locMgr && [[NSDate date] timeIntervalSinceDate:newLocation.timestamp] < 10)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[_locMgr stopUpdatingLocation];
		
		if (_newestLoc) [_newestLoc release];
		_newestLoc = [newLocation retain];
		
		[_dataStore removeAllObjects];
		[[NSNotificationCenter defaultCenter] postNotificationName:kFinishedLocatingNotification object:self];
	}
}

///// url connection stuff
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if ([response expectedContentLength] != NSURLResponseUnknownLength) {
		_tempLoadData = [[NSMutableData alloc] initWithCapacity:[response expectedContentLength]];
		_canMakeRequest = NO;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_tempLoadData && !_canMakeRequest)
	{
		[_tempLoadData appendData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSString* strData = [[NSString alloc] initWithBytes:[_tempLoadData bytes] length:[_tempLoadData length] encoding:NSUTF8StringEncoding];
	id jsonObj = nil;
	
	if (strData && (jsonObj = [strData JSONValue]))
	{
		NSDictionary* jsonDict = nil;
		
		if ([jsonObj isKindOfClass:[NSDictionary class]] && (jsonDict = [(NSDictionary*)jsonObj objectForKey:@"responseData"]))
		{
			NSEnumerator* resEnum = [(NSArray*)[jsonDict objectForKey:@"results"] objectEnumerator];
			NSDictionary* resObj = nil;
			
			if ([_dataStore count]) [_dataStore removeAllObjects];
			
			while ((resObj = [resEnum nextObject])) [_dataStore addObject:resObj];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kFinishedLoadingNotification object:self];
	
	[strData release];
	[_tempLoadData release];
	_tempLoadData = nil;
	_canMakeRequest = YES;
}
@end
