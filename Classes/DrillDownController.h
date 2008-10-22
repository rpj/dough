//
//  DrillDownController.h
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DrillDownController : UITableViewController {
	NSArray*		_info;
	CGRect			_givenFrame;
}

@property (nonatomic, retain) NSArray* detailInfo;
@property (nonatomic, assign) CGRect givenFrame;

@end
