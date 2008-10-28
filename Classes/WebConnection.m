//
//  WebConnection.m
//  Dough
//
//  Created by Ryan Joseph on 10/28/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "WebConnection.h"


@implementation WebConnection

@synthesize loadedData = _loadedData;
@dynamic loadedString;

- (NSString*) loadedString;
{
	if (!_loadedString && _loadedData)
	{
		_loadedString = [[NSString alloc] initWithBytes:[_tempLoadData bytes] 
												 length:[_tempLoadData length] 
											   encoding:NSUTF8StringEncoding];
	}
	
	return _loadedString;
}

- (id) init;
{
	if ((self = [super init]))
	{
		_tempLoadData = nil;
		_threadExitCondition = NO;
		_endSelector = nil;
		_targetObject = nil;
	}
	
	return self;
}

- (void) dealloc;
{
	[_tempLoadData release];
	[_targetObject release];
	[_loadedData release];
	[_loadedString release];
	
	[super dealloc];
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if (_loadedData) 
	{
		[_loadedData release];
		[_loadedString release];
		_loadedData = nil;
		_loadedString = nil;
	}
	
	_tempLoadData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_tempLoadData) [_tempLoadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSError* retErr = nil;
	
	if ([_tempLoadData length])
	{
		_loadedString = [[NSString alloc] initWithBytes:[_tempLoadData bytes] 
												 length:[_tempLoadData length] 
											   encoding:NSUTF8StringEncoding];
		
		retErr = [NSError errorWithDomain:@"us.seph.Dough.WebConnection" 
									 code:42 
								 userInfo:[NSDictionary 
										   dictionaryWithObjectsAndKeys:_loadedString, NSLocalizedDescriptionKey, nil]];
	}
	
	_loadedData = _tempLoadData;
	_tempLoadData = nil;
	
	if (_targetObject && _endSelector)
	{
		[_targetObject performSelector:_endSelector withObject:self withObject:retErr];
		[_targetObject release];
		_targetObject = nil;
		_endSelector = nil;
		
		_threadExitCondition = YES;
	}
}

+ (NSMutableURLRequest*) _prepareURLRequest:(NSString*)reqBody;
{
	NSMutableURLRequest* urlReq = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kWebServerURL]];
	
	[urlReq setHTTPMethod:@"POST"];
	[urlReq setHTTPShouldHandleCookies:NO];
	[urlReq setHTTPBody:[NSData dataWithBytes:[reqBody cStringUsingEncoding:NSASCIIStringEncoding]
									   length:[reqBody lengthOfBytesUsingEncoding:NSASCIIStringEncoding]]];
	
	return urlReq;
}

+ (NSData*) sendSynchronousRequest:(NSString*)request returningResponse:(NSURLResponse**)resp error:(NSError**)err;
{
	return [NSURLConnection sendSynchronousRequest:[self _prepareURLRequest:request] returningResponse:resp error:err];
}

- (void) _fireQuery:(id)arg;
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	NSString* reqBody = (NSString*)arg;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(_connectionEnded:) 
												 name:@"_connectionEnded"
											   object:nil];
	
	[NSURLConnection connectionWithRequest:[WebConnection _prepareURLRequest:reqBody] delegate:self];
	
	while (!_threadExitCondition)
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	
	[pool release];
}

- (void) sendRequest:(NSString*)request endSelector:(SEL)endSel targetObject:(id)obj;
{
	if (request && endSel && obj)
	{
		_endSelector = endSel;
		_targetObject = [obj retain];
		
		[NSThread detachNewThreadSelector:@selector(_fireQuery:) toTarget:self withObject:request];
	}
}
@end
