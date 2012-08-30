//
//  cs193CacheData.m
//  FlickrMonster
//
//  Created by Chris Blazek on 8/29/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import "cs193CacheData.h"

@implementation cs193CacheData
// URL of caches directory
static NSURL *cachesURL;

// file properties that we are interested in
static NSArray *fileProperties;

// Returns a file manager object
+ (NSFileManager *) fileManager
{
	// Use a new FileManager each time to ensure thread safety (I think!)
	return [[NSFileManager alloc ] init];
}


// Returns the URL for caches directory
+ (NSURL *) cachesURL
{
	if (!cachesURL) { // Create a handle to the URL for the caches directory (if none already)
		
		// Retrieve the URL of the Caches directory
		NSArray *cachesArray = [[self fileManager] URLsForDirectory:NSCachesDirectory
														  inDomains:NSUserDomainMask];
		// Sets the URL
		cachesURL = [cachesArray lastObject];
	}
	return cachesURL;
}


// Returns the file properties we have access to
+ (NSArray *) fileProperties
{
	if (!fileProperties) { // Create file properties array (if none already)
		
		fileProperties =
		[NSArray arrayWithObjects: NSURLNameKey, NSURLIsDirectoryKey, NSURLCreationDateKey, nil];
	}
	
	return fileProperties;
}


// Trims the cache to within the MAXIMUM_CACHE_SIZE limit, set in the header.
+ (void) trimCache
{
	// Get hold of the file manager
	NSFileManager *fileManager = [self fileManager];
	
	// Get a handle to all of the files in the caches directory
	NSArray *URLsInCache = [NSArray arrayWithArray:
							[fileManager contentsOfDirectoryAtURL:[self cachesURL]
									   includingPropertiesForKeys:[self fileProperties]
														  options:NSDirectoryEnumerationSkipsHiddenFiles
															error:nil]];
	
	// The current size of the cache
	int cacheSize = 0;
	
	// Go through the files and add up the file size
	for (NSURL *url in URLsInCache) {
		// Add the file size to the total file size
		cacheSize += [[[fileManager attributesOfItemAtPath:url.path
													 error:nil] valueForKey:NSFileSize] intValue];
	}
	
	NSLog(@"Cache Size is %d", cacheSize / 1000);
	
	if (cacheSize > MAXIMUM_CACHE_SIZE) { // Cache is too big
		
		// First sort the cache files into date order
		URLsInCache = [URLsInCache sortedArrayUsingComparator: ^(id item1, id item2) {
			
			NSDate *date1 = [ [fileManager attributesOfItemAtPath:[item1 path] error:nil]
							 valueForKey:NSFileModificationDate];
			NSDate *date2 = [ [fileManager attributesOfItemAtPath:[item2 path] error:nil]
							 valueForKey:NSFileModificationDate];
			return [date2 compare:date1];
		}];
		
		NSMutableArray *URLs = [NSMutableArray arrayWithArray:URLsInCache];
		
		// Not iterate over urls and keep deleting until cache is of the right size
		while (cacheSize > TRIM_CACHE_SIZE && URLs.count > 0) {
			
			// Get the URL of the last object in the list (the oldest object)
			NSURL *url = [URLs lastObject];
			
			// Get the attributes of the file
			NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:url.path error:nil];
			
			// Reduce the cache size count
			cacheSize -= [[fileAttributes valueForKey:NSFileSize] intValue];
			
			// Delete file from local array
			[URLs removeLastObject];
			
			// Delete the file (but only if not a directory)
			if ([fileAttributes valueForKey:NSFileType] == NSFileTypeRegular) {
				// Delete file from system
				[fileManager removeItemAtURL:url error:nil];
			}
		}
	}
}


// Helper method that returns the full URL for a given file name
+ (NSURL *) getURLForFile:(NSString *) fileName
{
	// Return the url for the file we are interested in
	return [NSURL URLWithString:fileName relativeToURL:[self cachesURL]];
}


// Returns data from the file system
+ (NSData*) fetchData:(NSString *) key
{
	
	// Return the file from the file system
	return [NSData dataWithContentsOfURL:[self getURLForFile:key]];
}


// Used to store data in the cache
+ (void) storeData:(NSString *)key: (NSData *) data
{
	// Write data to file system, will rewrite and get a new date stamp
	[data writeToURL: [self getURLForFile:key] atomically:true];
	
	// Here seems like a reasonable place to check that the cache is not getting to big
	// Will trim the cache asynchronously because it's an expensive process
	dispatch_queue_t dispatchQueue = dispatch_queue_create("q_trimCache", NULL);
	
	// Use the download queue to asynchronously get the list of Top Places
	dispatch_async(dispatchQueue, ^{ [self trimCache]; });
	
	// Release the queue
	dispatch_release(dispatchQueue);
}

@end

/*
thanks to https://github.com/i4-apps/Top-Places
 
// Cache the image
[cs193CacheData storeData:[self findPhotoID] :imageData];




- (NSData *) fetchImage {
	// Fetch the image from the cache
	NSData *image = [cs193CacheData fetchData:[self findPhotoID]];

	if (!image)
	// Retrieve the image from Flickr
	image = [NSData dataWithContentsOfURL:
	[FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge]];

	return image;
}
 
 */
