//
//  TableController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController, NavController;

@interface TableController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	NavController*							_navControl;
	
	DataController*							_dataControl;
	NSMutableArray*							_placeTypes;
	
	UITableView*							_tv;
}

@property (nonatomic, retain) NavController* navController;

@end
