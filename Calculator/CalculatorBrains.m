//
//  CalculatorBrains.m
//  Calculator
//
//  Created by Blazek Chris on 6/13/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "CalculatorBrains.h"

@interface CalculatorBrains()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrains

@synthesize operandStack = _operandStack;
- (NSMutableArray *) operandStack{ 
    if(!_operandStack)
        _operandStack = [[NSMutableArray alloc]init ];
    return _operandStack;
}

- (double) popOperand{
    NSNumber *operandObject = [self.operandStack lastObject];
    if(operandObject /*self.operandStack.count > 0*/)
        [self.operandStack  removeLastObject];
    return [operandObject doubleValue];
}

- (void) pushOperand:(double) operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void) clearStack
{
    [self.operandStack removeAllObjects ];
}

- (double) negateLastStackEntry
{
	double result = 0;
    result = -[self popOperand];
	[self pushOperand:result];
	
	return result;
}

- (double) performOperation:(NSString *) operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        result = [self popOperand] - [self popOperand];
    } else if ([operation isEqualToString:@"*"]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if(divisor)
            result = [self popOperand] / divisor;
        else 
            result = 0;
    }

    [self pushOperand:result];
    
    return result;
}

-(double) pushTrigFunction:(NSString *) operation
{
    double result = 0;
    
    if ([operation isEqualToString:@"Sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"Cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"Tan"]) {
        result = tan([self popOperand]);
    }

    [self pushOperand:result];
    
    return result;
}

// po [self operandStack]
// po self
-(NSString *)description
{
    return [NSString stringWithFormat:@"stack = %@", self.operandStack];
}

@end
