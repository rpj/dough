//
//  DataController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kStartingToLocateNotification		@"kDoughDataControllerStartingToLocate"
#define kStartingToLoadNotification			@"kDoughDataControllerStartingToLoad"
#define kFinishedLocatingNotification		@"kDoughDataControllerFinishedLocating"
#define kFinishedLoadingNotification		@"kDoughDataControllerFinishedLoading"

@interface DataController : NSObject <CLLocationManagerDelegate> {
	IBOutlet CLLocationManager*		_locMgr;
	
	CLLocation*						_newestLoc;
	
	NSMutableArray*					_dataStore;
	
	BOOL							_canMakeRequest;
	NSMutableData*					_tempLoadData;
}

@property (nonatomic, readonly) BOOL locationServicesEnabled;
@property (nonatomic, readonly) BOOL hasData;
@property (nonatomic, readonly, assign) NSArray* dataStore;
@property (nonatomic, readonly, assign) CLLocation* latestLocation;

- (void) startLoadingLocalInfoWithQueryString:(NSString*)query;
@end
