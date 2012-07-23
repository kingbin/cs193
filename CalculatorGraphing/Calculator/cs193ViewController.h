//
//  cs193ViewController.h
//  Calculator
//
//  Created by Blazek Chris on 6/11/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatableViewController.h"

@interface cs193ViewController : RotatableViewController

	@property (weak, nonatomic) IBOutlet UILabel *testDisplayStack;
	@property (weak, nonatomic) IBOutlet UILabel *displayHistory;
	@property (weak, nonatomic) IBOutlet UILabel *displayStack;

@end
