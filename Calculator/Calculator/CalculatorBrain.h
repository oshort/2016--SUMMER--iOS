//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Ben Gohlke on 3/5/15.
//  Copyright (c) 2015 The Iron Yard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (NSString *)addOperandDigit:(NSString *)digit;
- (NSString *)addOperator:(NSString *)operatorValue;
- (NSString *)performCalculationIfPossible;

@end