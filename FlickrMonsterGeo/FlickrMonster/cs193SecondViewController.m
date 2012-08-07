//
//  cs193SecondViewController.m
//  FlickrMonster
//
//  Created by Chris Blazek on 7/26/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import "cs193SecondViewController.h"

@interface cs193SecondViewController ()

@end

@implementation cs193SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

@end
