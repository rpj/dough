//
//  PageOneViewController.m
//  SourDough
//
//  Created by Ryan Joseph on 11/11/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "PageOneViewController.h"


@implementation PageOneViewController

- (IBAction) keypadButtonPressed:(id)button;
{
	int digit = -1;
	
	if (button == _oneButton)
		digit = 1;
	else if (button == _twoButton)
		digit = 2;
	else if (button == _threeButton)
		digit = 3;
	else if (button == _fourButton)
		digit = 4;
	else if (button == _fiveButton)
		digit = 5;
	else if (button == _sixButton)
		digit = 6;
	else if (button == _sevenButton)
		digit = 7;
	else if (button == _eightButton)
		digit = 8;
	else if (button == _nineButton)
		digit = 9;
	else if (button == _zeroButton)
		digit = 0;
	
	if (!_amtValue)
		_amtValue = [[NSMutableString string] retain];
	
	NSRange dotRange = [_amtValue rangeOfString:@"."];
	BOOL dotFound = (dotRange.location != NSNotFound);
	int amtLength = [_amtValue length];
	int dotToEnd = amtLength - dotRange.location;
	
	if (digit != -1)
	{
		if (!dotFound || (dotToEnd < 3)) 
			[_amtValue appendFormat:@"%d", digit];
	}
	else
	{
		if (button == _delButton && amtLength)
		{
			int num = (dotToEnd == 2 ? 2 : 1);
			[_amtValue deleteCharactersInRange:NSMakeRange([_amtValue length] - num, num)];
			
		}
		else if (button == _dotButton && !dotFound)
			[_amtValue appendString:([_amtValue length] ? @"." : @"0.")];
	}
	
	if ((![_amtValue doubleValue] && button != _dotButton) || ![_amtValue length])
	{
		[_amtValue release];
		_amtValue = nil;
	}
	
	if (_amtValue && [_amtValue length])
		_amtLabel.text = [NSString stringWithFormat:@"$%@", _amtValue];
	else
		_amtLabel.text = @"$0.00";
}


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	_amtLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:38.0];
	_amtValue = nil;
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
