//
//  MainViewController.m
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "DoughAppDelegate.h"
#import "NavController.h"
#import "TableController.h"

#define kLocatingString			@"Locating you..."
#define kTitleKey				@"titleNoFormatting"

@implementation MainViewController

///// view controller stuff

- (void) needToSave:(NSNotification*)notify;
{
	/*
	if (_amountGiven)
	{
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		NSMutableArray* writeArr = [NSMutableArray array];
		
		if ([defaults objectForKey:@"entriesToPost"])
			[writeArr addObjectsFromArray:(NSArray*)[defaults objectForKey:@"entriesToPost"]];
		
		NSMutableDictionary* dict = [NSMutableDictionary dictionary];
		
		[dict setObject:_amountField.text forKey:@"amount"];
		[dict setObject:[_methodControl titleForSegmentAtIndex:_methodControl.selectedSegmentIndex] forKey:@"paymentMethod"];
		[dict setObject:[self pickerView:_wherePicker titleForRow:[_wherePicker selectedRowInComponent:0] forComponent:0] forKey:@"abstractWhere"];
		[dict setObject:[NSDate date] forKey:@"date"];
		
		if (_locMgr.locationServicesEnabled && [_wherePicker selectedRowInComponent:1] > 0)
			[dict setObject:[_pickerData objectAtIndex:[_wherePicker selectedRowInComponent:1]] forKey:@"concreteWhere"];
		
		[writeArr addObject:dict];
		[defaults setObject:writeArr forKey:@"entriesToPost"];
		NSLog(@"save dict: %@", dict);
		
		NSLog(@"save successful? %d", [defaults synchronize]);
	}	
	 */
}

- (void) editingEnd:(UITextField*)sender
{
	if ([[_amountField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$"]] doubleValue])
	{
		NSLog(@"value looks valid, allowing it");
		_amountGiven = YES;
	}
}

- (void) editingChanged:(UITextField*)sender
{        
	static BOOL updatingText;
	static NSCharacterSet *invalidChars = nil;
    
	_amountGiven = NO;
	
    if (invalidChars == nil) {
        invalidChars = [[[NSCharacterSet characterSetWithCharactersInString:@"0123456789.$"] invertedSet] retain];
    }
	
	if (!updatingText)
	{
		updatingText = YES;
		
		if ([_amountField.text characterAtIndex:0] != '$')
		{
			_amountField.text = [NSString stringWithFormat:@"$%@", _amountField.text];
		}
		
		if ([_amountField.text length] > 1)
		{
			_amountField.text = [[_amountField.text stringByTrimmingCharactersInSet:invalidChars] 
								 stringByReplacingOccurrencesOfString:@".." withString:@"."];
			
			_amountField.text = [NSString stringWithFormat:@"$%@", 
								 [[_amountField.text substringFromIndex:1] stringByTrimmingCharactersInSet:
								  [NSCharacterSet characterSetWithCharactersInString:@"$"]]];
			
			NSArray* comps = [_amountField.text componentsSeparatedByString:@"."];
			if ([comps count] > 2)
			{
				_amountField.text = [NSString stringWithFormat:@"%@.%@", [comps objectAtIndex:0], [comps objectAtIndex:1]];
			}
		}
		
		updatingText = NO;
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
	{
		_amountGiven = NO;
		_lastSelectedWhereCat = 0;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToSave:) name:kNeedToSaveNotification object:nil];
	}
	
	return self;
}

- (void)viewDidLoad {
	_tableControl = [[TableController alloc] initWithStyle:UITableViewStylePlain];
	_navControl = [[NavController alloc] initWithRootViewController:_tableControl];
	[_tableView addSubview:[_navControl view]];
	_tableControl.navController = _navControl;
	
	_navControl.navigationBar.topItem.title = @"Where:";
	_navControl.navigationBar.tintColor = [UIColor darkGrayColor];
	_navControl.navigationBar.topItem.hidesBackButton = NO;
	
	_howMuchLabel.font = _methodLabel.font = [UIFont boldSystemFontOfSize:24];
	
	_amountField.font = [UIFont boldSystemFontOfSize:18];
	[_amountField addTarget:self action:@selector(editingEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[_amountField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
	
	_methodControl.tintColor = [UIColor grayColor];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	NSLog(@"\n\nMemory Warning!\n\n");
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[super dealloc];
}
@end
