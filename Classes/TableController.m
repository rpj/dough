//
//  TableController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "TableController.h"
#import "DataController.h"
#import "DrillDownController.h"
#import "NavController.h"

#import <CoreGraphics/CoreGraphics.h>

@implementation TableController

@synthesize navController = _navControl;

- (void) notify:(NSNotification*)notify;
{
	if ([[notify name] isEqualToString:kStartingToLocateNotification])
	{
		_navControl.navigationBar.topItem.prompt = @"Locating you; please wait...";
	}
	else if ([[notify name] isEqualToString:kStartingToLoadNotification])
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	}
	else
	{
		if ([[notify name] isEqualToString:kFinishedLoadingNotification] && _dataControl.hasData)
		{
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
		_navControl.navigationBar.backItem.prompt = nil;
	}
}

- (void) viewDidLoad;
{
	_placeTypes = [[NSMutableArray arrayWithObjects:@"Gas", @"Food", @"Coffee", @"Banking", @"Retail", @"Theatre", @"Hotels", nil] retain];
	
	NSNotificationCenter* ncent = [NSNotificationCenter defaultCenter];
	[ncent addObserver:self selector:@selector(notify:) name:kStartingToLocateNotification object:nil];
	[ncent addObserver:self selector:@selector(notify:) name:kStartingToLoadNotification object:nil];
	[ncent addObserver:self selector:@selector(notify:) name:kFinishedLocatingNotification object:nil];
	[ncent addObserver:self selector:@selector(notify:) name:kFinishedLoadingNotification object:nil];
	
	_dataControl = [[DataController alloc] init];
	
	_tv = (UITableView*)self.view;
	_givenFrame = self.view.frame;
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
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.lineBreakMode = UILineBreakModeTailTruncation;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.opaque = YES;
		
		UILabel* label = (UILabel*)[cell.contentView.subviews objectAtIndex:0];
		label.opaque = YES;
		label.text = [_placeTypes objectAtIndex:indexPath.row];
	}
	else
		[cell prepareForReuse];
	
	if (!_dataControl.hasData)
		cell.accessoryType = UITableViewCellAccessoryNone;
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if (indexPath.section == 0)
	{
		_fetchAfterLoc = ![_dataControl startLoadingLocalInfoWithQueryString:(_query = [_placeTypes objectAtIndex:indexPath.row])];
	}
}
@end
