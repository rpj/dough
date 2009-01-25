//
//  MainViewController.h
//  SourDough
//
//  Created by Ryan Joseph on 11/11/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController {
    UINavigationController*			_navControl;
	
	IBOutlet UILabel*		_speechLabel;
	IBOutlet UIImageView*	_bgImage;
}

- (IBAction) advanceToPageTwo:(id)sender;
@end
