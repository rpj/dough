//
//  TableController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController, NavController;

@interface TableController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	NavController*							_navControl;
	
	DataController*							_dataControl;
	NSMutableArray*							_placeTypes;
	
	UITableView*							_tv;
	NSString*								_query;
	
	BOOL									_fetchAfterLoc;
	
	CGRect									_givenFrame;
}

@property (nonatomic, retain) NavController* navController;
@property (nonatomic, readonly) UITableView* tableView;

@end
