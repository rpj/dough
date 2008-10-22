//
//  DrillDownController.m
//  Dough
//
//  Created by Ryan Joseph on 10/21/08.
//  Copyright 2008 Micromat, Inc.. All rights reserved.
//

#import "DrillDownController.h"


@implementation DrillDownController

@synthesize detailInfo = _info;
@synthesize givenFrame = _givenFrame;

- (void) viewDidLoad;
{
	self.view.frame = _givenFrame;
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
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.opaque = YES;
	cell.lineBreakMode = UILineBreakModeTailTruncation;
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	UILabel* label = (UILabel*)[cell.contentView.subviews objectAtIndex:0];
	label.opaque = YES;
	label.text = [(NSDictionary*)[_info objectAtIndex:indexPath.row] valueForKey:@"titleNoFormatting"];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	((UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath]).accessoryType = UITableViewCellAccessoryCheckmark;
}


/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
*/

- (void)dealloc {
    [super dealloc];
}


@end

