//
//  cs193FlickrMapViewController.h
//  FlickrMonster
//
//  Created by Chris Blazek on 8/6/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class cs193FlickrMapViewController;

@protocol cs193FlickrMapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(cs193FlickrMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface cs193FlickrMapViewController : UIViewController
@property (nonatomic, strong) NSArray *annotations; // of id <MKAnnotation>
@property (nonatomic, weak) id <cs193FlickrMapViewControllerDelegate> delegate;
@end