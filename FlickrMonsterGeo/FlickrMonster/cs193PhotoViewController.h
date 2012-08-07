//
//  cs193PhotoViewController.h
//  FlickrMonster
//
//  Created by Chris Blazek on 7/31/12.
//  Copyright (c) 2012 Chris Blazek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cs193PhotoViewController : UIViewController

@property (nonatomic,strong) NSDictionary *photoInfo;
- (void)setPhotoInfo:(NSDictionary *)photoInfo;

@end
