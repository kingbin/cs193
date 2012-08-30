//
//  cs193CacheData.h
//  FlickrMonster
//
//  Created by Chris Blazek on 8/29/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cs193CacheData : NSObject

// Constant to define the maximum size of the cache
#define MAXIMUM_CACHE_SIZE 10485760 // 10Mb

// Constant to define the trim size of the cache
#define TRIM_CACHE_SIZE 5242880 // 5Mb

// Used to fetch data from the cache
+ (NSData *) fetchData: (NSString *) key;

// Used to store data in the cache
+ (void) storeData: (NSString *)key: (NSData *) data;

@end