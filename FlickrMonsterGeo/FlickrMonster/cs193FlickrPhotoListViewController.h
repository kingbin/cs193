//
//  cs193FlickrPhotoListViewController.h
//  FlickrMonster
//
//  Created by Chris Blazek on 7/30/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cs193FlickrPhotoListViewController : UITableViewController

@property (nonatomic,strong) NSArray *photoList;
- (void)setPhotoList:(NSArray *)photoList withTitle:(NSString *)title;

@end