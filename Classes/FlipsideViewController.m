//
//  FlipsideViewController.m
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Ryan Joseph, 2008. All rights reserved.
//

#import "FlipsideViewController.h"
#import "NSString+Utils.h"
#import "WebConnection.h"
#import "DoughAppDelegate.h"

@implementation FlipsideViewController
- (void) webConnEnded:(WebConnection*)wConn withError:(NSError*)error;
{
	NSLog(@"webConnEnded: %@", wConn);
	
	if (!error)
		NSLog(@"connection was successful\n\n");
	else
		NSLog(@"Error: %@", error);
}

- (void) textFieldDidEndOnExit:(UITextField *)textField
{
	if (textField == _userField)
		[_passField becomeFirstResponder];
	else if (textField == _passField && _userField.text)
	{
		[WebConnection sendDoughRequest:
		 [NSString stringWithFormat:@"act=np&phid=%@&uname=%@&psha=%@", 
		  [DoughAppDelegate deviceSHA1], _userField.text, [_passField.text SHA1AsHex]]
							endSelector:@selector(webConnEnded:withError:) 
						   targetObject:self];
	}
}

- (void)viewDidLoad {
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	_dotComLabel.font = [UIFont boldSystemFontOfSize:18.0];
	[_userField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[_passField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
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
