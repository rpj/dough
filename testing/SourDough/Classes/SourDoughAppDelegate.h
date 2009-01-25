//
//  SourDoughAppDelegate.h
//  SourDough
//
//  Created by Ryan Joseph on 11/11/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface SourDoughAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

