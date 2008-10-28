//
//  MainViewController.m
//  Dough
//
//  Created by Ryan Joseph on 10/20/08.
//  Copyright Ryan Joseph, 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "DoughAppDelegate.h"
#import "TableController.h"
#import "DataController.h"

@implementation MainViewController

- (void) needToSave:(NSNotification*)notify;
{
	// when asked to save, the first thing we do is dump the current information to the user defaults
	// store, to ensure that at very least, what is on screen will be saved (as long as an amount is given)
	if (_amountGiven)
	{
		NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
		NSMutableArray* writeArr = [NSMutableArray array];
		
		if ([defaults objectForKey:kDoughEntriesDefaultsKey])
			[writeArr addObjectsFromArray:(NSArray*)[defaults objectForKey:kDoughEntriesDefaultsKey]];
		
		NSMutableDictionary* dict = [NSMutableDictionary dictionary];
		
		[dict setObject:_amountField.text forKey:@"amount"];
		[dict setObject:[_methodControl titleForSegmentAtIndex:_methodControl.selectedSegmentIndex] forKey:@"paymentMethod"];
		[dict setObject:[NSString stringWithFormat:@"%@", [NSDate date]] forKey:@"date"];
		
		if (_tableControl.location)
		{
			[dict setObject:[_tableControl.location description] forKey:@"location"];
		}
		
		[dict setObject:[_tableControl dictionaryForSelection] forKey:@"where"];
		
		[writeArr addObject:dict];
		[defaults setObject:writeArr forKey:kDoughEntriesDefaultsKey];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kSendToWebNowNotification object:self];
}

- (void) saveOpEnded:(NSNotification*)notify;
{
	if (_amountGiven)
	{
		[_navControl.navigationBar.topItem setLeftBarButtonItem:
		 [[[UIBarButtonItem alloc] initWithTitle:@"Save"
										   style:UIBarButtonItemStylePlain
										  target:self
										  action:@selector(save:)] autorelease] animated:YES];
	}
	else
		[_navControl.navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
}

- (void) save:(id)o;
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(saveOpEnded:)
												 name:kSaveOperationEndedNotification
											   object:nil];
	
	[_navControl.navigationBar.topItem setLeftBarButtonItem:
	 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
													target:self
													action:@selector(save:)] autorelease]
	 animated:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kNeedToSaveNotification object:self];
}

- (void) editingEnd:(UITextField*)sender
{
	_amountGiven = (BOOL)[[_amountField.text stringByTrimmingCharactersInSet:
						   [NSCharacterSet characterSetWithCharactersInString:@"$"]] doubleValue];
	
	if (_amountGiven && !_navControl.navigationBar.topItem.leftBarButtonItem)
	{
		[_navControl.navigationBar.topItem setLeftBarButtonItem:
		 [[[UIBarButtonItem alloc] initWithTitle:@"Save"
										   style:UIBarButtonItemStylePlain
										  target:self
										  action:@selector(save:)] autorelease] animated:YES];
	}
	else
		[_navControl.navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
		
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
		
		if ([_amountField.text length] && [_amountField.text characterAtIndex:0] != '$')
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

- (void) editingFinished:(id) sender;
{
	[_tableControl.tableView setEditing:NO animated:YES];
	_navControl.navigationBar.topItem.leftBarButtonItem = nil;
	_navControl.navigationBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																										  target:self
																										  action:@selector(edit:)] autorelease];
}

- (void) add:(id)sender;
{
}

- (void) edit:(id)sender;
{
	_navControl.navigationBar.topItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																										 target:self 
																										 action:@selector(editingFinished:)] autorelease];
	
	_navControl.navigationBar.topItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																										  target:self 
																										  action:@selector(add:)] autorelease];
	[_tableControl.tableView setEditing:YES animated:YES];
}

- (void) locatedNotify:(NSNotification*)notify;
{
	//_navControl.navigationBar.topItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidLoad {
	_tableView.autoresizesSubviews = NO;
	
	CGRect oFrame = _tableView.frame;
	oFrame.origin.x = 0;
	oFrame.origin.y = 0;
	oFrame.size.height -= 44;
	
	UITableView* table = [[UITableView alloc] initWithFrame:oFrame style:UITableViewStylePlain];
	_tableControl = [[TableController alloc] init];
	
	table.delegate = _tableControl;
	table.dataSource = _tableControl;
	table.autoresizingMask = UIViewAutoresizingNone;
	table.autoresizesSubviews = NO;
	table.contentMode = UIViewContentModeRedraw;
	table.backgroundColor = [UIColor blackColor];
	table.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	_tableControl.view = table;
	[_tableView addSubview:table];
	
	_navControl = [[UINavigationController alloc] initWithRootViewController:_tableControl];
	oFrame = _navControl.view.frame;
	oFrame.origin.y = 0;
	_navControl.view.frame = oFrame;
	[_tableView addSubview:[_navControl view]];
	
	_tableControl.navController = _navControl;
	
	_navControl.navigationBar.topItem.title = @"Where?";
	_navControl.navigationBar.barStyle = UIBarStyleBlackOpaque;
	_navControl.navigationBar.topItem.hidesBackButton = NO;
	
	UIBarButtonItem* bButt = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
																			target:self
																			action:@selector(edit:)] autorelease];
	bButt.enabled = NO;
	_navControl.navigationBar.topItem.rightBarButtonItem = bButt;
	
	_howMuchLabel.font = _methodLabel.font = [UIFont boldSystemFontOfSize:20];
	
	_amountField.font = [UIFont boldSystemFontOfSize:18];
	_amountField.backgroundColor = _methodControl.backgroundColor = [UIColor clearColor];
	[_amountField addTarget:self action:@selector(editingEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[_amountField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
	
	_methodControl.tintColor = [UIColor darkGrayColor];
	[_tableControl viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locatedNotify:) name:kFinishedLocatingNotification object:nil];
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
