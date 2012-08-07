//
//  cs193FlickrTopPlacesViewController.m
//  FlickrMonster
//
//  Created by Chris Blazek on 7/26/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import "cs193FlickrTopPlacesViewController.h"
#import "FlickrFetcher/FlickrFetcher.h"

#import "cs193FlickrPhotoListViewController.h"

@interface cs193FlickrTopPlacesViewController ()
	@property (nonatomic) NSArray *flickrPlaces;
	@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation cs193FlickrTopPlacesViewController

@synthesize flickrPlaces = _flickrPlaces;


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
	//self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.flickrPlaces = [FlickrFetcher topPlaces];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.flickrPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"topPlaces";
	
    UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
				initWithStyle:UITableViewCellStyleDefault
				reuseIdentifier:CellIdentifier];
    }
	
    NSDictionary *topPlacesDictionary = [self.flickrPlaces objectAtIndex:indexPath.row];
    NSString *topPlacesDescription = [topPlacesDictionary objectForKey:@"_content"];
    
    NSRange commaLocation = [topPlacesDescription rangeOfString:@","];
    
    if(commaLocation.location == NSNotFound)
        cell.textLabel.text = topPlacesDescription;
    else {
        cell.textLabel.text = [topPlacesDescription substringToIndex:commaLocation.location];
        cell.detailTextLabel.text = [topPlacesDescription substringFromIndex:(commaLocation.location + 1)];
     }
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

	NSArray *photosList = [FlickrFetcher photosInPlace:[self.flickrPlaces objectAtIndex:indexPath.row] maxResults:50 ];
	[segue.destinationViewController setPhotoList:photosList withTitle:[[self.flickrPlaces objectAtIndex:indexPath.row] objectForKey:@"_content"] ];
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
//	NSLog(@"didSelectRowAtIndexPath HIT");
}

@end
