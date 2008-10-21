//
//  TableController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController;

@interface TableController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UINavigationController*		_navControl;
	
	DataController*							_dataControl;
	NSMutableArray*							_placeTypes;
	
	UITableView*							_tv;
}

@end
