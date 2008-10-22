//
//  MainViewController.h
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Ryan Joseph, 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableController;

@interface MainViewController : UIViewController {
	IBOutlet UILabel*					_howMuchLabel;
	IBOutlet UILabel*					_methodLabel;
	
	IBOutlet UITextField*				_amountField;
	IBOutlet UISegmentedControl*		_methodControl;
	
	IBOutlet UIView*					_tableView;
	IBOutlet UINavigationController*	_navControl;
	IBOutlet TableController*			_tableControl;
	
	BOOL								_amountGiven;
	NSUInteger							_lastSelectedWhereCat;
}

@end
