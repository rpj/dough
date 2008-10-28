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

@implementation FlipsideViewController
- (void) webConnEnded:(WebConnection*)wConn withError:(NSError*)error;
{
	NSLog(@"webConnEnded: %@", wConn);
	
	if (!error)
		NSLog(@"connection was successful\n\n");
	else
		NSLog(@"Error: %@", error);
	
	[wConn release];
}

- (void) textFieldDidEndOnExit:(UITextField *)textField
{
	if (textField == _userField)
		[_passField becomeFirstResponder];
	else if (textField == _passField)
	{
		//NSString* passSHA = [_passField.text SHA1AsHex];
		/*[[[WebConnection alloc] init] sendRequest:@"act=ta&sha=f00ba4&json=[]&phid=butthole" 
									  endSelector:@selector(webConnEnded:withError:) 
									 targetObject:self];*/
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
