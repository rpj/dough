//
//  MainViewController.m
//  SourDough
//
//  Created by Ryan Joseph on 11/11/08.
//  Copyright Micromat, Inc. 2008. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "PageOneViewController.h"
#import "PageTwoViewController.h"

const int kDoughHourAdd				= 4;

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	NSArray* bgImages = [NSArray arrayWithObjects:@"blimp-bg-0-earlymorning", @"blimp-bg-1-morning",
						 @"blimp-bg-2-midday", @"blimp-bg-3-evening", @"blimp-bg-4-night", @"blimp-bg-5-latenight", nil];
	NSDateComponents* now = [[NSCalendar autoupdatingCurrentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
	int index = (int)(([now hour] + kDoughHourAdd) / [bgImages count]);
	NSString* fname = [NSString stringWithFormat:@"%@.png", [bgImages objectAtIndex:index]];
	UIImage* img = [UIImage imageNamed:fname];
	[_bgImage setImage:img];
	NSLog(@"%d %d %@ %@ %@", [now hour], index, [bgImages objectAtIndex:index], fname, img);
	
	PageOneViewController* pageOne = [[[PageOneViewController alloc] initWithNibName:@"PageOne" bundle:nil] autorelease];
	_navControl = [[UINavigationController alloc] initWithRootViewController:pageOne];
	_navControl.navigationBarHidden = YES;
	
	_speechLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:28.0];
	
	[self.view addSubview:_navControl.view];
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advanceToPageTwo:) name:@"pageForward" object:nil];
}

- (IBAction) advanceToPageTwo:(id)sender;
{
	PageTwoViewController* pageTwo = [[[PageTwoViewController alloc] initWithNibName:@"PageTwo" bundle:nil] autorelease];
	[_navControl pushViewController:pageTwo animated:YES];
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
