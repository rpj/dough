//
//  WebConnection.h
//  Dough
//
//  Created by Ryan Joseph on 10/28/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWebServerURL		@"http://24.130.91.57/cgi-bin/doughTest.cgi"

@interface WebConnection : NSObject {
	NSMutableData*			_tempLoadData;
	NSData*					_loadedData;
	NSString*				_loadedString;
	
	SEL						_endSelector;
	id						_targetObject;
	
	BOOL					_threadExitCondition;
}

@property (nonatomic, readonly) NSData* loadedData;
@property (nonatomic, readonly) NSString* loadedString;

+ (void) sendDoughRequest:(NSString*)request endSelector:(SEL)endSel targetObject:(id)obj;
+ (NSData*) sendSynchronousDoughRequest:(NSString*)request returningResponse:(NSURLResponse**)resp error:(NSError**)err;
@end
