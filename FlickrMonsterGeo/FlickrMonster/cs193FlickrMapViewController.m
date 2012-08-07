//
//  cs193FlickrMapViewController.m
//  FlickrMonster
//
//  Created by Chris Blazek on 8/6/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import "cs193FlickrMapViewController.h"

@interface cs193FlickrMapViewController () <MKMapViewDelegate>
	@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end


@implementation cs193FlickrMapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
