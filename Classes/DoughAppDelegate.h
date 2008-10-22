//
//  DoughAppDelegate.h
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNeedToSaveNotification				@"kDoughNeedToSaveNotification"
#define kSendToWebNowNotification			@"kDoughSendToWebNowNotification"
#define kDrillDownSelectNotification		@"kDoughDrillDownSelectNotification"
#define kStartingToLocateNotification		@"kDoughDataControllerStartingToLocate"
#define kStartingToLoadNotification			@"kDoughDataControllerStartingToLoad"
#define kFinishedLocatingNotification		@"kDoughDataControllerFinishedLocating"
#define kFinishedLoadingNotification		@"kDoughDataControllerFinishedLoading"

@class RootViewController;

@interface DoughAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet RootViewController *rootViewController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) RootViewController *rootViewController;

@end

