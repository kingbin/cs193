//
//  cs193PhotoViewController.m
//  FlickrMonster
//
//  Created by Chris Blazek on 7/31/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import "cs193PhotoViewController.h"
#import "FlickrFetcher/FlickrFetcher.h"

@interface cs193PhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *flickrImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation cs193PhotoViewController

@synthesize flickrImageView = _flickrImageView;
@synthesize scrollView = _scrollView;

@synthesize photoInfo = _photoInfo;
- (void)setPhotoInfo:(NSDictionary *)photoInfo {
	_photoInfo = photoInfo;
}
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
	
	self.scrollView.delegate = self;
//    self.scrollView.contentSize = self.flickrImageView.image.size;
//    self.flickrImageView.frame = CGRectMake(0, 0, self.flickrImageView.image.size.width, self.flickrImageView.image.size.height);
}

- (void)viewDidUnload
{
	[self setFlickrImageView:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.flickrImageView;
}


- (void)loadFlickrImage{
	NSData *img = [NSData dataWithContentsOfURL:[FlickrFetcher urlForPhoto:self.photoInfo format:FlickrPhotoFormatLarge]];

	self.flickrImageView.image = [UIImage imageWithData:img];
	self.title = [self.photoInfo objectForKey:@"title"];
	
	self.scrollView.contentSize = self.flickrImageView.image.size;
	self.scrollView.zoomScale = 1;
	self.flickrImageView.frame = CGRectMake(0, 0, self.flickrImageView.image.size.width, self.flickrImageView.image.size.height);
	
	float widthRatio = self.view.bounds.size.width / self.flickrImageView.image.size.width;
	float heightRatio = self.view.bounds.size.height / self.flickrImageView.image.size.height;
	self.scrollView.zoomScale = MAX(widthRatio, heightRatio);
}

- (void)viewWillAppear:(BOOL)animated {
	if(self.photoInfo) [self loadFlickrImage];
}

@end
