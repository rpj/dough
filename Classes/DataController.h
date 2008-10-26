//
//  DataController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Ryan Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DataController : NSObject <CLLocationManagerDelegate> {
	IBOutlet CLLocationManager*		_locMgr;
	
	CLLocation*						_newestLoc;
	CLLocation*						_oldLoc;
	
	NSMutableArray*					_dataStore;
	
	BOOL							_canMakeRequest;
	NSMutableData*					_tempLoadData;
}

@property (nonatomic, readonly) BOOL locationServicesEnabled;
@property (nonatomic, readonly) BOOL hasData;
@property (nonatomic, readonly, assign) NSArray* dataStore;
@property (nonatomic, readonly, assign) CLLocation* latestLocation;

- (BOOL) startLoadingLocalInfoWithQueryString:(NSString*)query;
@end
