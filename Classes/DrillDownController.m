//
//  DrillDownController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Ryan Joseph. All rights reserved.
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
		
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.lineBreakMode = UILineBreakModeTailTruncation;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
		cell.backgroundView.backgroundColor = [UIColor blackColor];
		cell.opaque = YES;
		
		// kill the pre-built label
		[(UILabel*)[cell.contentView.subviews objectAtIndex:0] removeFromSuperview];
		
		CGRect lFrame = cell.frame;
		lFrame.size.height /= 2;
		lFrame.size.width -= 10;
		lFrame.origin.x += 10;
		lFrame.origin.y += 5;
		
		UILabel* label = [[[UILabel alloc] initWithFrame:lFrame] autorelease];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor blackColor];
		label.opaque = YES;
		cell.font = label.font = [UIFont boldSystemFontOfSize:18.0];
		
		lFrame.origin.y += 15;
		UILabel* addrLabel = [[[UILabel alloc] initWithFrame:lFrame] autorelease];
		addrLabel.textColor = [UIColor lightTextColor];
		addrLabel.backgroundColor = label.backgroundColor;
		addrLabel.font = [UIFont systemFontOfSize:12.0];
		addrLabel.opaque = YES;
		
		addrLabel.textAlignment = label.textAlignment = UITextAlignmentCenter;
		
		NSDictionary* infoDict = [_info objectAtIndex:indexPath.row];
		NSMutableString* labelStr = [NSMutableString stringWithString:@"No results"];
		
		if (infoDict)
		{
			labelStr = [NSMutableString string];
			[labelStr appendString:[infoDict valueForKey:@"titleNoFormatting"]];
			
			NSArray* addrLines = [infoDict valueForKey:@"addressLines"];
			if (addrLines && [addrLines count])
			{
				addrLabel.text = [addrLines objectAtIndex:0];
				[cell.contentView addSubview:addrLabel];
			}
			else
			{
				lFrame.origin.y -= 8;
				label.frame = lFrame;
			}
		}
		
		label.text = labelStr;
		
		[cell.contentView addSubview:label];
		[cell.contentView sendSubviewToBack:cell.backgroundView];
	}
	else
		[cell prepareForReuse];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if (indexPath.row < [_info count])
	{
		UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
		
		if (_lastSelect)
		{
			UITableViewCell* tCell = (UITableViewCell*)[tableView cellForRowAtIndexPath:_lastSelect];
			tCell.accessoryType = UITableViewCellAccessoryNone;
			//((UILabel*)[tCell.contentView.subviews objectAtIndex:0]).textColor = [UIColor whiteColor];
			//((UILabel*)[tCell.contentView.subviews objectAtIndex:1]).textColor = [UIColor lightTextColor];
			[_lastSelect release];
		}
		
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		_lastSelect = [indexPath retain];
		[[NSNotificationCenter defaultCenter] postNotificationName:kDrillDownSelectNotification 
															object:self 
														  userInfo:[_info objectAtIndex:indexPath.row]];
		
		//((UILabel*)[cell.contentView.subviews objectAtIndex:0]).textColor = 
		//	((UILabel*)[cell.contentView.subviews objectAtIndex:1]).textColor = [UIColor blackColor];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

