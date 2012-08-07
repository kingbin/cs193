//
//  NSObject+Players.h
//  FlickrMonster
//
//  Created by Chris Blazek on 7/27/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *game;
@property (nonatomic, assign) int rating;
@end