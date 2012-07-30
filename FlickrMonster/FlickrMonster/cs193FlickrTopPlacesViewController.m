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
@end

@implementation cs193FlickrTopPlacesViewController

@synthesize flickrPlaces = _flickrPlaces;
@synthesize flickrPhotos = _flickrPhotos;

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
	
//	// How many top places in the array?
//	NSLog(@"Number of top places returned: %i", [self.flickrPlaces count]);
//	
//	// What type of object is the value in the array?
//	Class arrayObjectClass = [[self.flickrPlaces objectAtIndex:0] class];
//	NSLog(@"Top places is an array of: %@", NSStringFromClass(arrayObjectClass));
//	
//	// Display the contents of the first item in the array
//	NSLog(@"The description of the first top place is %@:",
//		  [[self.flickrPlaces objectAtIndex:0] description]);
	
	
	//[self loadPlayers];
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
	
	if (!self.tableView && [segue.identifier isEqualToString:@"ShowGraph"]) {
		NSArray *photosList = [FlickrFetcher photosInPlace:[self.flickrPlaces objectAtIndex:indexPath.row] maxResults:50 ];
		
		[segue.destinationViewController setPhotoList:photosList withTitle:@"test" ];
	}
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


//- (void) loadPlayers
//{
//	NSMutableArray *players = [NSMutableArray arrayWithCapacity:20];
//	Player *player = [[Player alloc] init];
//	player.name = @"Bill Evans";
//	player.game = @"Tic-Tac-Toe";
//	player.rating = 4;
//	[players addObject:player];
//	player = [[Player alloc] init];
//	player.name = @"Oscar Peterson";
//	player.game = @"Spin the Bottle";
//	player.rating = 5;
//	[players addObject:player];
//	player = [[Player alloc] init];
//	player.name = @"Dave Brubeck";
//	player.game = @"Texas Hold’em Poker";
//	player.rating = 2;
//	[players addObject:player];
//	self.Players = players;
//}

@end
