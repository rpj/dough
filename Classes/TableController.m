//
//  TableController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Ryan Joseph. All rights reserved.
//

#import "TableController.h"
#import "DataController.h"
#import "DrillDownController.h"
#import "DoughAppDelegate.h"

#import <CoreGraphics/CoreGraphics.h>

@implementation TableController

@dynamic location;

- (CLLocation*) location;
{
	return _dataControl.locationServicesEnabled ? _dataControl.latestLocation : nil;
}

@synthesize navController = _navControl;
@synthesize tableView = _tv;

- (void) notify:(NSNotification*)notify;
{
	if ([[notify name] isEqualToString:kStartingToLocateNotification])
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	else if ([[notify name] isEqualToString:kStartingToLoadNotification])
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	else
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if ([[notify name] isEqualToString:kFinishedLoadingNotification] && _dataControl.hasData)
		{
			[_tv cellForRowAtIndexPath:[_tv indexPathForSelectedRow]].accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			DrillDownController* drillDown = [[DrillDownController alloc] initWithStyle:UITableViewStylePlain];
			drillDown.detailInfo = _dataControl.dataStore;
			drillDown.givenFrame = self.view.frame;
			
			[_navControl pushViewController:drillDown animated:YES];
			_navControl.navigationBar.topItem.title = _query;
			[drillDown release];
		}
		else if ([[notify name] isEqualToString:kFinishedLocatingNotification] && _fetchAfterLoc && _query) 
		{
			_fetchAfterLoc = ![_dataControl startLoadingLocalInfoWithQueryString:_query];
		}
			
		_navControl.navigationBar.topItem.prompt = nil;
	}
}

- (NSDictionary*) dictionaryForSelection;
{
	NSMutableDictionary* dict = [NSMutableDictionary dictionary];
	
	NSIndexPath* ipath = [self.tableView indexPathForSelectedRow];
	
	if (ipath.row < [_placeTypes count])
	{
		[dict setObject:[_placeTypes objectAtIndex:ipath.row] forKey:@"abstract"];
	}
	
	if (_concreteWhereInfo)
	{
		[dict setObject:_concreteWhereInfo forKey:@"concrete"];
	}
	
	return (NSDictionary*)dict;
}

- (void) concreteWhere:(NSNotification*)notify;
{
	NSDictionary* uinfo = [notify userInfo];
	
	if (uinfo)
	{
		if (_concreteWhereInfo) [_concreteWhereInfo release];
		_concreteWhereInfo = [uinfo retain];
	}
}

- (void) viewDidLoad;
{
	_placeTypes = [[NSMutableArray arrayWithObjects:@"Gas", @"Food", @"Coffee", @"Banking", 
					@"Shopping", @"Grocery", @"Utility", @"Movie Theaters", @"Entertainment", 
					@"Hotels", @"Bars", @"Nightlife", @"Transportation", @"Custom Search...", nil] retain];
	
	NSNotificationCenter* ncent = [NSNotificationCenter defaultCenter];
	
	[ncent addObserver:self selector:@selector(notify:) name:kStartingToLocateNotification object:nil];
	[ncent addObserver:self selector:@selector(notify:) name:kStartingToLoadNotification object:nil];
	[ncent addObserver:self selector:@selector(notify:) name:kFinishedLocatingNotification object:nil];
	[ncent addObserver:self selector:@selector(notify:) name:kFinishedLoadingNotification object:nil];
	
	[ncent addObserver:self selector:@selector(concreteWhere:) name:kDrillDownSelectNotification object:nil];
	
	_dataControl = [[DataController alloc] init];
	
	_tv = (UITableView*)self.view;
	_givenFrame = self.view.frame;
	
	_concreteWhereInfo = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (_givenFrame.size.height != tableView.frame.size.height)
		tableView.frame = _givenFrame;
	
	NSString* cellID = [NSString stringWithFormat:@"iPath(%@)", indexPath];
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellID] autorelease];
	}
	else
		[cell prepareForReuse];
	
	if (!_dataControl.hasData)
		cell.accessoryType = UITableViewCellAccessoryNone;
	
	cell.accessoryType = _dataControl.locationServicesEnabled ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	cell.lineBreakMode = UILineBreakModeTailTruncation;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
	cell.backgroundView.backgroundColor = [UIColor blackColor];
	cell.opaque = YES;
	
	UILabel* label = (UILabel*)[cell.contentView.subviews objectAtIndex:0];
	label.textColor = [UIColor whiteColor];
	label.text = [_placeTypes objectAtIndex:indexPath.row];
	label.opaque = YES;
	[cell.contentView addSubview:label];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:
			return [_placeTypes count];
	}
	
	return 0;
}

/// for UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		UITextField* search = (UITextField*)[alertView.subviews objectAtIndex:0];
		[_dataControl startLoadingLocalInfoWithQueryString:search.text];
		[search removeFromSuperview];
		[search release];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section == 0)
	{
		if (indexPath.row == ([_placeTypes count] - 1))
		{
			UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Search Google Local:" 
																  message:@" " 
																 delegate:self 
														cancelButtonTitle:@"Cancel" 
														otherButtonTitles:@"Search", nil];
			UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
			
			myTextField.font = [UIFont boldSystemFontOfSize:18];
			[myTextField setBackgroundColor:[UIColor whiteColor]];
			[myAlertView insertSubview:myTextField atIndex:0];
			
			CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
			[myAlertView setTransform:myTransform];
			
			[myAlertView show];
			[myTextField becomeFirstResponder];
			[myAlertView release];
			
		}
		else
		{
			NSString* pString = nil;
			
			if (!_dataControl.latestLocation)
				pString = @"Locating you...";
			
			_fetchAfterLoc = ![_dataControl startLoadingLocalInfoWithQueryString:(_query = [_placeTypes objectAtIndex:indexPath.row])];
			
			if (pString)
				_navControl.navigationBar.topItem.prompt = pString;
		}
	}
}
@end
