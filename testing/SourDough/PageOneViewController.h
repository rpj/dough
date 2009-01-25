//
//  PageOneViewController.h
//  SourDough
//
//  Created by Ryan Joseph on 11/11/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PageOneViewController : UIViewController {
	IBOutlet UILabel*		_amtLabel;
	IBOutlet UIButton*		_oneButton;
	IBOutlet UIButton*		_twoButton;
	IBOutlet UIButton*		_threeButton;
	IBOutlet UIButton*		_fourButton;
	IBOutlet UIButton*		_fiveButton;
	IBOutlet UIButton*		_sixButton;
	IBOutlet UIButton*		_sevenButton;
	IBOutlet UIButton*		_eightButton;
	IBOutlet UIButton*		_nineButton;
	IBOutlet UIButton*		_zeroButton;
	IBOutlet UIButton*		_dotButton;
	IBOutlet UIButton*		_delButton;
	
	NSMutableString*		_amtValue;
}

- (IBAction) keypadButtonPressed:(id)button;
@end
