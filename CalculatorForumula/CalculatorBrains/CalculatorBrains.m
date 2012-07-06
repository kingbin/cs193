//
//  CalculatorBrains.m
//  Calculator
//
//  Created by Blazek Chris on 6/13/12.
//  Copyright (c) 2012 628 Productions. All rights reserved.
//

#import "CalculatorBrains.h"

@interface CalculatorBrains()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrains

@synthesize programStack = _programStack;
- (NSMutableArray *) programStack{ 
    if(!_programStack)
        _programStack = [[NSMutableArray alloc]init ];
    return _programStack;
}

- (void) pushOperand:(double) operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double) performOperation:(NSString *) operation
{
	[self.programStack addObject:operation];
	
	
	// temp dictionary values until I build out the rest
	NSArray *keys = [NSArray arrayWithObjects:@"x",@"y",@"z",nil];
	NSArray *values =  [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:20],[NSNumber numberWithInt:30],nil];
	
	return [CalculatorBrains runProgram:self.program usingVariables:[NSDictionary dictionaryWithObjects:values forKeys:keys]];
}

- (id)program
{
	return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
	return @"Assignment 2";
}


+ (double) runProgram:(id)program usingVariables:(NSDictionary *)varaibleValues
{
	NSMutableArray *stack;
	if([program isKindOfClass:[NSArray class]])
		stack = [program mutableCopy];

	// cycle through applying variable values
	
	return [self popOperandOffStack:stack];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
	double result = 0;
    
	id topOfStack = [stack lastObject];
	
	if(topOfStack) [stack removeLastObject];
	
	if([topOfStack isKindOfClass:[NSNumber class]])
		result = [topOfStack doubleValue];
	else if([topOfStack isKindOfClass:[NSString class]]){
		
		NSString *operation = topOfStack;
		
		if ([operation isEqualToString:@"+"]) {
			result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
		} else if ([operation isEqualToString:@"-"]) {
			double subtrahend = [self popOperandOffStack:stack];
			result = [self popOperandOffStack:stack] - subtrahend;
		} else if ([operation isEqualToString:@"*"]) {
			result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
		} else if ([operation isEqualToString:@"/"]) {
			double divisor = [self popOperandOffStack:stack];
			if(divisor)
				result = [self popOperandOffStack:stack] / divisor;
			else 
				result = 0;
		}
	}
	
	return result;
}



/* Assignment  1
 **************************************/
- (void) clearStack
{
//	[self.programStack removeAllObjects ];
}

- (double) negateLastStackEntry
{
	double result = 0;
//    result = -[self popOperand];
//	[self pushOperand:result];
//	
	return result;
}

-(double) pushTrigFunction:(NSString *) operation
{
    double result = 0;
    
//    if ([operation isEqualToString:@"Sin"]) {
//        result = sin([self popOperand]);
//    } else if ([operation isEqualToString:@"Cos"]) {
//        result = cos([self popOperand]);
//    } else if ([operation isEqualToString:@"Tan"]) {
//        result = tan([self popOperand]);
//    } else if ([operation isEqualToString:@"sqrt"]) {
//        result = sqrt([self popOperand]);
//    }
//
//    [self pushOperand:result];
    
    return result;
}

// po [self operandStack]
// po self
-(NSString *)description
{
    return [NSString stringWithFormat:@"stack = %@", self.programStack];
}

@end
