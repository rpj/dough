//
//  TableController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Ryan Joseph. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class DataController, NavController;

@interface TableController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	UINavigationController*					_navControl;
	
	DataController*							_dataControl;
	NSMutableArray*							_placeTypes;
	
	UITableView*							_tv;
	NSString*								_query;
	
	BOOL									_fetchAfterLoc;
	
	CGRect									_givenFrame;
	
	NSDictionary*							_concreteWhereInfo;
}

@property (nonatomic, retain) UINavigationController* navController;
@property (nonatomic, readonly) UITableView* tableView;
@property (nonatomic, readonly) CLLocation* location;

- (NSDictionary*) dictionaryForSelection;

@end
