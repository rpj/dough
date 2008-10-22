//
//  DataController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "DataController.h"
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
		
		if (_locMgr.locationServicesEnabled)
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:kStartingToLocateNotification object:self];
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
										   coord.latitude, coord.longitude, query]];
		
		NSLog(@"Attempting request with URL: %@", url);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
		
		return YES;
	}
	
	return NO;
}

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
	if (manager == _locMgr)
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
