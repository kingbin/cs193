//
//  cs193ViewController.m
//  Calculator
//
//  Created by Blazek Chris on 6/11/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "cs193ViewController.h"
#import "CalculatorBrains.h"

#include <math.h>

@interface cs193ViewController ()
	@property (nonatomic) BOOL userEnteringNumber;
	@property (nonatomic, strong) CalculatorBrains *brains;
@end

@implementation cs193ViewController

    @synthesize displayStack = _displayStack;
	@synthesize displayHistory = _displayHistory;
    @synthesize userEnteringNumber = _userEnteringNumber;

    @synthesize brains = _brains;
    - (CalculatorBrains *) brains{ 
        if(!_brains) _brains = [[CalculatorBrains alloc]init ];
        return _brains;
    }

    - (IBAction)digitPressed:(UIButton *)sender {

//		UIButton *button = (UIButton *)sender;
//		int btnTag = [button superview].tag;
		
        if( [sender.currentTitle isEqualToString:@"."] 
		   && [self.displayStack.text rangeOfString:@"."].location != NSNotFound)
                return;
        else if(self.userEnteringNumber) {
			
			if([sender.currentTitle isEqualToString:@"π"] || [sender tag] == 1)
				return;
			else if([sender.currentTitle isEqualToString:@"+/-"])
				self.displayStack.text = [NSString stringWithFormat:@"%g", -[self.displayStack.text doubleValue]];
			else if([sender.currentTitle isEqualToString:@"<-"]){
				self.displayStack.text = [self.displayStack.text substringToIndex:[self.displayStack.text length] - 1 ];
				//self.displayHistory.text = [self.displayHistory.text substringToIndex:[self.displayHistory.text length] - 1];
				if([self.displayStack.text length] == 0){
					self.displayStack.text = @"0";
					self.userEnteringNumber = NO;
				}
			}
			else 
				self.displayStack.text = [self.displayStack.text stringByAppendingString:sender.currentTitle];
			
		}
        else if( !self.userEnteringNumber ){
			
			if([sender.currentTitle isEqualToString:@"π"]){
				self.displayStack.text = [NSString stringWithFormat:@"%16.9g\n", M_PI];
				[self.brains pushOperand:[self.displayStack.text doubleValue]];
				self.displayHistory.text = [self.displayHistory.text stringByAppendingFormat:@" %@", sender.currentTitle];
			}
			else if([sender tag] == 1){
				self.displayStack.text = sender.currentTitle;
				[self.brains pushVariable:self.displayStack.text];
				self.displayHistory.text = [self.displayHistory.text stringByAppendingFormat:@" %@", sender.currentTitle];
			}
			else if([sender.currentTitle isEqualToString:@"+/-"]){
				self.displayStack.text = [NSString stringWithFormat:@"%16.9g", [self.brains negateLastStackEntry]];
				//self.displayHistory.text = [self.displayHistory.text stringByAppendingFormat:@" %@", sender.currentTitle];
			}
			else if([sender.currentTitle isEqualToString:@"<-"]){
				return; // lazy and just won't allow the user to backspace if they're currently not in enteringnumber mode
			}
			else {
				self.displayStack.text = sender.currentTitle;
				self.userEnteringNumber = YES;
			}
			
        }
    }

    - (IBAction)calculatorFXN:(UIButton *)sender {
        if([sender.currentTitle isEqualToString:@"Enter"]) {
			self.displayHistory.text = [self.displayHistory.text stringByAppendingFormat:@" %@", self.displayStack.text];
			[self.brains pushOperand:[self.displayStack.text doubleValue]];
		}
        else if([sender.currentTitle isEqualToString:@"AC"]) {
			self.displayHistory.text = @"";
            [self.brains clearStack];
            self.displayStack.text = @"0";
        }
        self.userEnteringNumber = NO;
    }

    - (IBAction)operatorPressed:(UIButton *)sender {
        if(self.userEnteringNumber) {
			[self.brains pushOperand:[self.displayStack.text doubleValue]];
			self.displayHistory.text = [self.displayHistory.text stringByAppendingFormat:@" %@", self.displayStack.text];
        }
        self.displayStack.text = [NSString stringWithFormat:@"%g", [self.brains performOperation:sender.currentTitle]];
        self.userEnteringNumber = NO;
		
		self.displayHistory.text = [self.displayHistory.text stringByAppendingFormat:@" %@", sender.currentTitle];
    }

    - (IBAction)trigFunction:(UIButton *)sender {
        self.displayStack.text = [NSString stringWithFormat:@"%g", [self.brains pushTrigFunction:sender.currentTitle]];
    }

	- (IBAction)testFXN:(UIButton *)sender {
		switch (sender.tag) {
			case 2:
				// test condition 1
				break;
			case 3:
				// test condition 1
				break;
			case 4:
				// test condition 1
				break;
			default:
				NSLog(@"Unmapped Tag For Test Condition Method!");
				break;
		}
	}

@end
