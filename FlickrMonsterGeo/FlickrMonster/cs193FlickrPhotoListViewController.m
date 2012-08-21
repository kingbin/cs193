//
//  cs193FlickrPhotoListViewController.m
//  FlickrMonster
//
//  Created by Chris Blazek on 7/30/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import "cs193FlickrPhotoListViewController.h"
#import "cs193PhotoViewController.h"
#import "cs193FlickrMapViewController.h"

#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher/FlickrFetcher.h"

#define LASTVIEWED_KEY @"Ccs193FlickrPhotoListViewController.LastViewed"

@interface cs193FlickrPhotoListViewController () <cs193FlickrMapViewControllerDelegate>

@end

@implementation cs193FlickrPhotoListViewController

@synthesize photoList = _photoList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
\
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if([segue.identifier isEqualToString:@"ShowImage"]){
		NSDictionary *photosInfo = [self.photoList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		NSMutableArray *lastViewed = [[defaults objectForKey:LASTVIEWED_KEY] mutableCopy];
		if(!lastViewed) lastViewed = [NSMutableArray array];
		
		if(![lastViewed containsObject:photosInfo]){
			[lastViewed addObject:photosInfo];
			[defaults setObject:lastViewed forKey:LASTVIEWED_KEY];
			[defaults synchronize];
		}
		
		[segue.destinationViewController setPhotoInfo:photosInfo ];
	}
	else if( !self.splitViewController && [segue.identifier isEqualToString:@"ShowMap"] ){
		cs193FlickrMapViewController *controller = (cs193FlickrMapViewController *)segue.destinationViewController;
        controller.delegate = self;
		[segue.destinationViewController setAnnotations:[self mapAnnotations]];
	}
}


#pragma mark - TableView Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photoList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
        cell = [[UITableViewCell alloc]
				initWithStyle:UITableViewCellStyleDefault
				reuseIdentifier:CellIdentifier];
    }
	
    NSDictionary *photoListDictionary = [self.photoList objectAtIndex:indexPath.row];

	cell.textLabel.text = [photoListDictionary objectForKey:@"title"];
	if(cell.textLabel.text.length <= 0) cell.textLabel.text = @"No Title";
	cell.detailTextLabel.text = [[photoListDictionary objectForKey:@"description"] objectForKey:@"_content"];
	if(cell.detailTextLabel.text.length <= 0) cell.detailTextLabel.text = @"No Description";

    return cell;
}


#pragma mark - PhotoListViewController Public Functions
- (void)setPhotoList:(NSArray *)photoList withTitle:(NSString *)title {
	self.photoList = photoList;
	self.title = title;
}


#pragma mark - MapViewControllerDelegate
- (UIImage *)mapViewController:(cs193FlickrMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation
{
    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return data ? [UIImage imageWithData:data] : nil;
}

//- (UIView *)mapViewController:(cs193FlickrMapViewController *)sender viewForSegue:(id <MKAnnotation>)annotation
//{
//    FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)annotation;
//	NSDictionary *photosInfo = fpa.photo;
//
//	[segue.destinationViewController setPhotoInfo:photosInfo ];
//	[self performSegueWithIdentifier:@"ShowImage" sender:self];
//}



#pragma mark - MapviewController Annotations Helper
- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photoList count]];
    for (NSDictionary *photo in self.photoList) {
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
