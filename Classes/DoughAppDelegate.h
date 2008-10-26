//
//  DoughAppDelegate.h
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Ryan Joseph, 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNeedToSaveNotification				@"kDoughNeedToSaveNotification"
#define kSendToWebNowNotification			@"kDoughSendToWebNowNotification"
#define kDrillDownSelectNotification		@"kDoughDrillDownSelectNotification"
#define kStartingToLocateNotification		@"kDoughDataControllerStartingToLocate"
#define kStartingToLoadNotification			@"kDoughDataControllerStartingToLoad"
#define kFinishedLocatingNotification		@"kDoughDataControllerFinishedLocating"
#define kFinishedLoadingNotification		@"kDoughDataControllerFinishedLoading"

#define kDoughEntriesDefaultsKey			@"us.seph.Dough.Defaults.EntriesToPost"
#define kDoughDeviceRegisteredDefaultsKey	@"us.seph.Dough.Defaults.DeviceRegistered"

@class RootViewController;

@interface DoughAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet RootViewController *rootViewController;
	
	/////
	NSMutableData*					_tempLoadData;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;

+ (NSString*) deviceSHA1;

@end

