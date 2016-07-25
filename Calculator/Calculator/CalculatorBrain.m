//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Ben Gohlke on 3/5/15.
//  Copyright (c) 2015 The Iron Yard. All rights reserved.
//

#import "CalculatorBrain.h"

typedef enum
{
    OperatorTypeNone,
    OperatorTypeAddition,
    OperatorTypeSubtraction,
    OperatorTypeMultiplication,
    OperatorTypeDivision
} OperatorType;

@interface CalculatorBrain ()

@property (nonatomic, copy) NSMutableString *operand1String;
@property (nonatomic, copy) NSMutableString *operand2String;

@property (assign) OperatorType operatorType;

@end

@implementation CalculatorBrain

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _operand1String = [[NSMutableString alloc] init];
        _operand2String = [[NSMutableString alloc] init];
        _operatorType = OperatorTypeNone;
    }
    
    return self;
}

- (NSString *)addOperandDigit:(NSString *)digit
{
    NSString *returnString;
    
    if (self.operatorType == OperatorTypeNone)
    {
        if ([digit isEqualToString:@"●"])
        {
            if (![self.operand1String containsString:@"."])
            {
                [self.operand1String appendString:@"."];
            }
        }
        else
        {
            [self.operand1String appendString:digit];
        }
        returnString = self.operand1String;
    }
    else
    {
        if ([digit isEqualToString:@"●"])
        {
            if (![self.operand2String containsString:@"."])
            {
                [self.operand2String appendString:@"."];
            }
        }
        else
        {
            [self.operand2String appendString:digit];
        }
        returnString = self.operand2String;
    }
    
    return returnString;
}

- (NSString *)addOperator:(NSString *)operatorValue
{
    NSString *returnString = nil;
    
    if ([operatorValue isEqualToString:@"√"])
    {
        returnString = [self performSquareRoot];
    }
    else if ([operatorValue isEqualToString:@"%"])
    {
        returnString = [self makePercent];
    }
    else if ([operatorValue isEqualToString:@"+/-"])
    {
        returnString = [self flipSign];
    }
    else if (self.operatorType == OperatorTypeNone && ![self.operand1String isEqualToString:@""])
    {
        if ([operatorValue isEqualToString:@"+"])
        {
            self.operatorType = OperatorTypeAddition;
        }
        else if ([operatorValue isEqualToString:@"−"])
        {
            self.operatorType = OperatorTypeSubtraction;
        }
        else if ([operatorValue isEqualToString:@"×"])
        {
            self.operatorType = OperatorTypeMultiplication;
        }
        else if ([operatorValue isEqualToString:@"÷"])
        {
            self.operatorType = OperatorTypeDivision;
        }
    }
    
    return returnString;
}

- (NSString *)flipSign
{
    if (![self.operand2String isEqualToString:@""])
    {
        double operand = [self.operand2String doubleValue];
        if (operand != 0)
        {
            // flips positive to negative and vice versa
            operand = operand * -1;
            [self.operand2String setString:[NSString stringWithFormat:@"%g", operand]];
            return self.operand2String;
        }
    }
    else if (![self.operand1String isEqualToString:@""])
    {
        double operand = [self.operand1String doubleValue];
        if (operand != 0)
        {
            // flips positive to negative and vice versa
            operand = operand * -1;
            [self.operand1String setString:[NSString stringWithFormat:@"%g", operand]];
            return self.operand1String;
        }
    }
    
    return nil;
}

- (NSString *)makePercent
{
    if (![self.operand2String isEqualToString:@""])
    {
        double operand = [self.operand2String doubleValue];
        // Convert number to percentage
        operand = operand * 0.01f;
        [self.operand2String setString:[NSString stringWithFormat:@"%g", operand]];
        return self.operand2String;
    }
    else if (![self.operand1String isEqualToString:@""])
    {
        double operand = [self.operand1String doubleValue];
        // Convert number to percentage
        operand = operand * 0.01f;
        [self.operand1String setString:[NSString stringWithFormat:@"%g", operand]];
        return self.operand1String;
    }
    
    return nil;
}

- (NSString *)performSquareRoot
{
    if (![self.operand2String isEqualToString:@""])
    {
        double operand = [self.operand2String doubleValue];
        if (operand >= 0)
        {
            operand = sqrt(operand);
            [self.operand2String setString:[NSString stringWithFormat:@"%g", operand]];
            return self.operand2String;
        }
        else
        {
            return @"Error";
        }
    }
    else if (![self.operand1String isEqualToString:@""])
    {
        double operand = [self.operand1String doubleValue];
        if (operand >= 0)
        {
            operand = sqrt(operand);
            [self.operand1String setString:[NSString stringWithFormat:@"%g", operand]];
            return self.operand1String;
        }
        else
        {
            return @"Error";
        }
    }
    
    return nil;
}

- (NSString *)performCalculationIfPossible
{
    // If we have 2 operands and an operator, we can perform the calculation
    if (![self.operand1String isEqualToString:@""] && ![self.operand2String isEqualToString:@""] && self.operatorType != OperatorTypeNone)
    {
        double operand1 = [self.operand1String doubleValue];
        double operand2 = [self.operand2String doubleValue];
        
        double answer = 0;
        
        switch (self.operatorType)
        {
            case OperatorTypeAddition:
                answer = operand1 + operand2;
                break;
            case OperatorTypeSubtraction:
                answer = operand1 - operand2;
                break;
            case OperatorTypeMultiplication:
                answer = operand1 * operand2;
                break;
            case OperatorTypeDivision:
                if (operand2 != 0)
                {
                    answer = operand1 / operand2;
                }
                else
                {
                    // Cannot divide by 0
                    return @"Error";
                }
                break;
                
            default:
                break;
        }
        
        // Calculation successful, return answer
        return [NSString stringWithFormat:@"%g", answer];
    }
    
    // We don't have all the components necessary to perform a transaction so return nil
    return nil;
}

@end