//
//  DrillDownController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "DrillDownController.h"
#import "DoughAppDelegate.h"

@implementation DrillDownController

@synthesize detailInfo = _info;
@synthesize givenFrame = _givenFrame;

- (void) viewDidLoad;
{
	self.view.frame = _givenFrame;
	self.view.backgroundColor = [UIColor blackColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {	
	if (section == 0)
	{
		return [_info count];
	}
	
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (_givenFrame.size.height != tableView.frame.size.height)
		tableView.frame = _givenFrame;
	
	NSString *CellIdentifier = [NSString stringWithFormat:@"DrillDownCell[%@]", indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.lineBreakMode = UILineBreakModeTailTruncation;
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
	cell.backgroundView.backgroundColor = [UIColor blackColor];
	cell.opaque = YES;
	
	UILabel* label = (UILabel*)[cell.contentView.subviews objectAtIndex:0];
	label.textColor = [UIColor whiteColor];
	label.text = [(NSDictionary*)[_info objectAtIndex:indexPath.row] valueForKey:@"titleNoFormatting"];
	label.opaque = YES;
	[cell.contentView addSubview:label];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.row < [_info count])
	{
		if (_lastSelect)
		{
			((UITableViewCell*)[tableView cellForRowAtIndexPath:_lastSelect]).accessoryType = UITableViewCellAccessoryNone;
			[_lastSelect release];
		}
		
		((UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).accessoryType = UITableViewCellAccessoryCheckmark;
		_lastSelect = [indexPath retain];
		[[NSNotificationCenter defaultCenter] postNotificationName:kDrillDownSelectNotification 
															object:self 
														  userInfo:[_info objectAtIndex:indexPath.row]];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

