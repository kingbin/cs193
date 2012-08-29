//
//  cs193FlickrMapViewController.m
//  FlickrMonster
//
//  Created by Chris Blazek on 8/6/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import "cs193FlickrMapViewController.h"
#import "FlickrPhotoAnnotation.h"

#import "cs193PhotoViewController.h"
#define LASTVIEWED_KEY @"Ccs193FlickrPhotoListViewController.LastViewed"

@interface cs193FlickrMapViewController () <MKMapViewDelegate>
	@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//	@property (weak, nonatomic) MKCoordinateRegion region;
@end


@implementation cs193FlickrMapViewController

@synthesize mapView = _mapView;
- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

@synthesize annotations = _annotations;
- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

@synthesize delegate = _delegate;

//@synthesize region = _region;

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}


#pragma mark - Autorotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

#pragma mark - Synchronize Model and View
// - (void)setMapView:(MKMapView *)mapView{...}
- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
	
	// http://brianreiter.org/2012/03/02/size-an-mkmapview-to-fit-its-annotations-in-ios-without-futzing-with-coordinate-systems/
    [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
}


#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    int count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        // could put a rightCalloutAccessoryView here
		aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
	
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = [self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	//NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
	
    FlickrPhotoAnnotation *fa = view.annotation;
    id vc = [self.splitViewController.viewControllers lastObject];
    if ([vc isKindOfClass:[cs193PhotoViewController class]])
        [vc setPhoto:fa.photo];
    else {
        [self performSegueWithIdentifier:@"ShowImage" sender:fa.photo];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if( [[segue identifier] isEqualToString:@"ShowImage"] ) {
		
/*********
	Prob need to move this chunk out of this perpareForSegue & PhotoListViewController as well and add to the photoviewcontroller */
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSMutableArray *lastViewed = [[defaults objectForKey:LASTVIEWED_KEY] mutableCopy];
		if(!lastViewed) lastViewed = [NSMutableArray array];
		
		if(![lastViewed containsObject:sender]){
			[lastViewed addObject:sender];
			[defaults setObject:lastViewed forKey:LASTVIEWED_KEY];
			[defaults synchronize];
		}
/*********/
		
		[segue.destinationViewController performSelector:@selector(setPhotoInfo:) withObject:sender];
	}
}

@end



