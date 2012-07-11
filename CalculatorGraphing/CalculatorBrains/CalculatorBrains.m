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
	@property (nonatomic, strong) NSDictionary *calcVariables;
@end

@implementation CalculatorBrains

/* Public Instance Variables
 *****************************************************/
- (id)program
{
	return [self.programStack copy];
}

/* Private Instance Variables
 *****************************************************/
	@synthesize programStack = _programStack;
	- (NSMutableArray *) programStack{ 
		if(!_programStack)
			_programStack = [[NSMutableArray alloc]init ];
		return _programStack;
	}

	@synthesize calcVariables = _calcVariables;
	- (NSDictionary *) calcVariables{ 
		
		if(!_calcVariables){ 
			_calcVariables = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"x"
							  , [NSNumber numberWithInt:0],@"y"
							  , [NSNumber numberWithInt:0],@"z", nil];
		}
		
		return _calcVariables;
	}

/* Public Instance Methods
 *****************************************************/
	- (void) pushOperand:(double) operand
	{
		[self.programStack addObject:[NSNumber numberWithDouble:operand]];
	}

	- (void) pushVariable:(NSString *) variable
	{
		[self.programStack addObject:variable];
	}

	- (double) performOperation:(NSString *) operation
	{
		[self.programStack addObject:operation];
		// vs. [CalculatorBrains runProgram] self class allows subclass to override our runProgram method
		return [[self class] runProgram:self.program usingVariables:[self.calcVariables dictionaryWithValuesForKeys:[[CalculatorBrains variablesUsedInProgram:self.program] allObjects]]];
	}

	- (NSString *) getProgramDescription
	{
		return [CalculatorBrains descriptionOfProgram:self.program];
	}

/* Class Methods
 *****************************************************/
	+ (double) runProgram:(id)program usingVariables:(NSDictionary *)varaibleValues
	{
		NSMutableArray *stack;
		if([program isKindOfClass:[NSArray class]])
			stack = [program mutableCopy];

		// cycle through applying variable values
		NSEnumerator *enumerator = [varaibleValues keyEnumerator];
		id key;
		while ((key = [enumerator nextObject])) {
			NSIndexSet *indexes = [stack indexesOfObjectsPassingTest:
								   ^BOOL (id v, NSUInteger i, BOOL *stop) {
									   return [key isEqual:v];
								   }];
			if(indexes.count > 0){
				NSArray *a = [NSArray arrayWithObject:[varaibleValues valueForKey:key]];
				[stack replaceObjectsAtIndexes:indexes withObjects:a];
			}
		}
		
/*		
		NSArray *keys = [NSArray arrayWithObjects:@"x",@"y",@"z", nil];
		
		NSIndexSet *indexes = [keys indexesOfObjectsPassingTest:
							   ^BOOL (id v, NSUInteger i, BOOL *stop) {
								   return [program containsObject:v];
							   }];
		if(indexes.count > 0)
			return [NSSet setWithArray:[keys objectsAtIndexes:indexes]];
*/		
		
		return [self popOperandOffStack:stack];
	}

	+ (NSString *)descriptionOfProgram:(id)program
	{
		NSMutableArray *stack;
		if([program isKindOfClass:[NSArray class]])
			stack = [program mutableCopy];

		NSString *programDescription = @"";
		while (stack.count) {
			programDescription = [programDescription stringByAppendingString:[self descriptionOfTopOfStack:stack]];
			if (stack.count) {
				programDescription = [programDescription stringByAppendingString:@", "];
			}
		}
		return programDescription;
	}


/* Private Class Methods
 *****************************************************/
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
			else if ([CalculatorBrains isSingleOperand:operation]) {
				result = [CalculatorBrains performSingleOperandFunction:operation withValue:[self popOperandOffStack:stack]];
			}
		}
		
		return result;
	}

	+(double) performSingleOperandFunction:(NSString *)operation withValue:(double)value {
		double result = 0;
		
		if ([operation isEqualToString:@"Sin"]) result = sin(value);
		else if ([operation isEqualToString:@"Cos"]) result = cos(value);
		else if ([operation isEqualToString:@"Tan"]) result = tan(value);
		else if ([operation isEqualToString:@"sqrt"]) result = sqrt(value);

		return result;
	}

	+ (NSSet *)variablesUsedInProgram:(id)program{
		if([program isKindOfClass:[NSArray class]]){
			NSArray *keys = [NSArray arrayWithObjects:@"x",@"y",@"z", nil];
			
			NSIndexSet *indexes = [keys indexesOfObjectsPassingTest:
								   ^BOOL (id v, NSUInteger i, BOOL *stop) {
									   return [program containsObject:v];
								   }];
			if(indexes.count > 0)
				return [NSSet setWithArray:[keys objectsAtIndexes:indexes]];
		}
		
		return nil;
	}

	+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack 
	{
		NSString *result = @"";
		
		id topOfStack = [stack lastObject];
		
		if(topOfStack) [stack removeLastObject];
		
		if([topOfStack isKindOfClass:[NSNumber class]])
			result = [result stringByAppendingFormat:@"%@ ",topOfStack];
		else if([topOfStack isKindOfClass:[NSString class]]){
			
			NSString *operation = topOfStack;
			
			if ([CalculatorBrains isNoOperand:operation]) {
				result = [NSString stringWithFormat:@"%@ ", operation];
			} else if ([CalculatorBrains isSingleOperand:operation]) {
				NSString * lastDigits = [self descriptionOfTopOfStack:stack];
				result = [NSString stringWithFormat:@"%@(%@) ", operation, [lastDigits substringToIndex:lastDigits.length - 1 ]];
			} else if ([CalculatorBrains isMultiOperand:topOfStack]) {
				NSString * lastDigits = [self descriptionOfTopOfStack:stack];
				NSString * lastDigits2 = [self descriptionOfTopOfStack:stack];
				result = [NSString stringWithFormat:@"(%@ %@ %@) ",[lastDigits2 substringToIndex:lastDigits2.length - 1 ], operation, [lastDigits substringToIndex:lastDigits.length - 1 ]];
			} 
		}

		return result;
	}

	+ (BOOL)isSingleOperand:(NSString *)operation { return [[NSArray arrayWithObjects:@"sqrt",@"Sin",@"Cos",@"Tan", nil] containsObject:operation]; }
	+ (BOOL)isNoOperand:(NSString *)operation { return [[NSArray arrayWithObjects:@"π",@"x",@"y",@"z", nil] containsObject:operation]; }
	+ (BOOL)isMultiOperand:(NSString *)operation { return [[NSArray arrayWithObjects:@"+",@"-",@"*",@"/", nil] containsObject:operation]; }





	/* Assignment  1
	 **************************************/
	- (void) clearStack
	{
		[self.programStack removeAllObjects ];
	}

	- (double) negateLastStackEntry
	{
		double result = 0;
	//    result = -[self popOperand];
	//	[self pushOperand:result];
	//	
		return result;
	}

	// po [self operandStack]
	// po self
	-(NSString *)description
	{
		return [NSString stringWithFormat:@"stack = %@", self.programStack];
	}

@end
