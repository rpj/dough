//
//  MainViewController.h
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MainViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate> {
	IBOutlet UILabel*				_howMuchLabel;
	IBOutlet UILabel*				_methodLabel;
	IBOutlet UILabel*				_whereLabel;
	
	IBOutlet UITextField*			_amountField;
	IBOutlet UISegmentedControl*	_methodControl;
	IBOutlet UIPickerView*			_wherePicker;
	
	CLLocationManager*				_locMgr;
	CLLocation*						_newestLoc;
	
	NSMutableData*					_tempURLData;
	
	NSMutableArray*					_pickerData;
	NSMutableArray*					_placeTypes;
	
	BOOL							_canReqAgain;
	BOOL							_amountGiven;
	NSUInteger						_lastSelectedWhereCat;
}

@end
