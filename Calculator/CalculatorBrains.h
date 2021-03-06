//
//  CalculatorBrains.h
//  Calculator
//
//  Created by Blazek Chris on 6/13/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrains : NSObject
- (void) pushOperand:(double) operand;
- (double) performOperation:(NSString *) operation;
- (double) pushTrigFunction:(NSString *) operation;
- (void) clearStack;
- (double) negateLastStackEntry;
@end
