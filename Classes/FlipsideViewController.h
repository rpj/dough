//
//  FlipsideViewController.h
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Ryan Joseph, 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlipsideViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UILabel*			_dotComLabel;
	IBOutlet UITextField*		_userField;
	IBOutlet UITextField*		_passField;
}

@end
