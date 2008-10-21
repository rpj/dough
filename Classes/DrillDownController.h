//
//  DrillDownController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrillDownController : UITableViewController {
	NSDictionary*		_info;
}

@property (nonatomic, retain) NSDictionary* detailInfo;

@end
