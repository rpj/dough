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
		_navControl.navigationBar.topItem.prompt = @"Locating you...";
	}
	else if ([[notify name] isEqualToString:kStartingToLoadNotification])
	{
		_navControl.navigationBar.topItem.prompt = @"Loading local data...";
	}
	else
	{
		if ([[notify name] isEqualToString:kFinishedLoadingNotification] && _dataControl.hasData)
		{
			[_tv cellForRowAtIndexPath:[_tv indexPathForSelectedRow]].accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			
			DrillDownController* drillDown = [[DrillDownController alloc] initWithStyle:UITableViewStylePlain];
			drillDown.detailInfo = _dataControl.dataStore;
			
			[_navControl pushViewController:drillDown animated:YES];
			_navControl.navigationBar.topItem.title = _query;
			[drillDown release];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
		[_dataControl startLoadingLocalInfoWithQueryString:(_query = [_placeTypes objectAtIndex:indexPath.row])];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 35.0;
}
@end
