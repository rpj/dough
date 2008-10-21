//
//  NavController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "NavController.h"


@implementation NavController
- (void)viewDidLoad
{
	[self pushViewController:_tableControl animated:NO];
	self.navigationBar.tintColor = [UIColor darkGrayColor];
	self.navigationBar.topItem.title = @"Where:";
}
@end