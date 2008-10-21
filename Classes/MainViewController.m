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

#import <JSON/JSON.h>

#define kLocatingString			@"Locating you..."
#define kTitleKey				@"titleNoFormatting"

@implementation MainViewController
///// url connection stuff
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if ([response expectedContentLength] != NSURLResponseUnknownLength) {
		_tempURLData = [[NSMutableData alloc] initWithCapacity:[response expectedContentLength]];
		_canReqAgain = NO;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (_tempURLData && !_canReqAgain)
	{
		[_tempURLData appendData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	NSString* strData = [[NSString alloc] initWithBytes:[_tempURLData bytes] length:[_tempURLData length] encoding:NSUTF8StringEncoding];
	id jsonObj = nil;
	
	if (strData && (jsonObj = [strData JSONValue]))
	{
		NSDictionary* jsonDict = nil;
		
		if ([jsonObj isKindOfClass:[NSDictionary class]] && (jsonDict = [(NSDictionary*)jsonObj objectForKey:@"responseData"]))
		{
			NSEnumerator* resEnum = [(NSArray*)[jsonDict objectForKey:@"results"] objectEnumerator];
			NSDictionary* resObj = nil;
			
			if ([_pickerData count]) [_pickerData removeAllObjects];
			
			[_pickerData addObject:[NSDictionary dictionaryWithObject:@"(None)" forKey:kTitleKey]];
			while ((resObj = [resEnum nextObject])) [_pickerData addObject:resObj];
			
			[_wherePicker reloadAllComponents];
		}
	}
	
	[strData release];
	[_tempURLData release];
	_tempURLData = nil;
	_canReqAgain = YES;
}

///// location stuff

- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
	if (manager == _locMgr)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[_locMgr stopUpdatingLocation];
		
		if (_newestLoc) [_newestLoc release];
		_newestLoc = [newLocation retain];
		
		[_pickerData removeAllObjects];
		
		if ([_wherePicker selectedRowInComponent:0])
		{
			[_pickerData addObject:[NSDictionary dictionaryWithObject:@"Loading..." forKey:kTitleKey]];
			[self pickerView:_wherePicker didSelectRow:[_wherePicker selectedRowInComponent:0] inComponent:0];
		}
		
		[_wherePicker reloadComponent:1];
	}
}

///// view controller stuff

- (void) needToSave:(NSNotification*)notify;
{
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
		_locMgr = [[CLLocationManager alloc] init];
		_locMgr.delegate = self;
		_locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		_locMgr.distanceFilter = 2.0;
		
		_pickerData = [[NSMutableArray alloc] init];
		_placeTypes = [[NSMutableArray arrayWithObjects:@"(None)", @"Gas", @"Food", @"Coffee", @"Banking", @"Retail", @"Theatre", @"Hotels", nil] retain];
		
		_newestLoc = nil;
		
		_canReqAgain = YES;
		_amountGiven = NO;
		_lastSelectedWhereCat = 0;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToSave:) name:kNeedToSaveNotification object:nil];
	}
	
	return self;
}

- (void)viewDidLoad {
	_howMuchLabel.font = _whereLabel.font = _methodLabel.font = [UIFont boldSystemFontOfSize:24];
	
	_amountField.font = [UIFont boldSystemFontOfSize:18];
	[_amountField addTarget:self action:@selector(editingEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
	[_amountField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
	
	_methodControl.tintColor = [UIColor grayColor];
	
	if (_locMgr.locationServicesEnabled)
	{
		[_pickerData addObject:[NSDictionary dictionaryWithObject:kLocatingString forKey:kTitleKey]];
		[_wherePicker reloadComponent:1];
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		[_locMgr startUpdatingLocation];
	}
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
	[_locMgr stopUpdatingLocation];
	[_locMgr release];
	
	[_pickerData release];
	[_placeTypes release];
	
	[super dealloc];
}


///// picker view delegates
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	switch (component)
	{
		case 0:
			return [_placeTypes count];
			
		case 1:
			return [_pickerData count];
	}
	
	return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return (_locMgr.locationServicesEnabled) ? 2 : 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return (_locMgr.locationServicesEnabled) ? ((component == 0) ? 80 : 220) : 300;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
	if (component == 0 && row <= [_placeTypes count])
	{
		return [_placeTypes objectAtIndex:row];
	}
	else if (component == 1 && row <= [_pickerData count])
	{
		return [(NSDictionary*)[_pickerData objectAtIndex:row] valueForKey:kTitleKey];
	}
	
	return @"No Title";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0 && row && row <= [_placeTypes count] && row != _lastSelectedWhereCat)
	{
		if (_newestLoc && _canReqAgain)
		{
			[_pickerData removeAllObjects];
			[_pickerData addObject:[NSDictionary dictionaryWithObject:@"Loading..." forKey:kTitleKey]];
			[_wherePicker reloadComponent:1];
			
			CLLocationCoordinate2D coord = _newestLoc.coordinate;
			
			NSURL* url = [NSURL URLWithString:
						  [NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large&sll=%f,%f&q=%@",
						   coord.latitude, coord.longitude, [_placeTypes objectAtIndex:row]]];
			
			NSLog(@"Attempting request with URL: %@", url);
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			[NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
			
			_lastSelectedWhereCat = row;
		}
	}
}
@end
