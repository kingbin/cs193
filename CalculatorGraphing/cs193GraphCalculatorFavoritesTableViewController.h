//
//  cs193GraphCalculatorFavoritesTableViewController.h
//  Calculator
//
//  Created by Chris Blazek on 7/30/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cs193GraphCalculatorFavoritesTableViewController;

@protocol cs193GraphCalculatorFavoritesTableViewControllerDelegate <NSObject>
@optional
-(void)cs193GraphCalculatorFavoritesTableViewController:(cs193GraphCalculatorFavoritesTableViewController *)sender choseProgram:(id)program;
@end

@interface cs193GraphCalculatorFavoritesTableViewController : UITableViewController

@property (nonatomic, strong)NSArray *programs; // of CalculatorBrain Programs
@property (nonatomic, weak) id <cs193GraphCalculatorFavoritesTableViewControllerDelegate> delegate;

@end
