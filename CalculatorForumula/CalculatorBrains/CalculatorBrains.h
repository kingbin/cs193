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
- (void) pushVariable:(NSString *) variable;
- (double) performOperation:(NSString *) operation;

- (double) pushTrigFunction:(NSString *) operation;
- (void) clearStack;
- (double) negateLastStackEntry;

@property (readonly) id program;

+ (double) runProgram:(id)program usingVariables:(NSDictionary *)varaibleValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL)isOperation:(NSString *)operation;

@end
