//
//  MainViewController.h
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavController, TableController;

@interface MainViewController : UIViewController {
	IBOutlet UILabel*					_howMuchLabel;
	IBOutlet UILabel*					_methodLabel;
	
	IBOutlet UITextField*				_amountField;
	IBOutlet UISegmentedControl*		_methodControl;
	
	BOOL								_amountGiven;
	NSUInteger							_lastSelectedWhereCat;
	
	IBOutlet UIView*					_tableView;
	IBOutlet NavController*				_navControl;
	IBOutlet TableController*			_tableControl;
}

@end
