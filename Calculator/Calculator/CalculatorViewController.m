//
//  ViewController.m
//  Calculator
//
//  Created by Ben Gohlke on 3/4/15.
//  Copyright (c) 2015 The Iron Yard. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) CalculatorBrain *brain;

- (IBAction)operandTapped:(UIButton *)sender;
- (IBAction)operatorTapped:(UIButton *)sender;
- (IBAction)clearTransaction:(UIButton *)sender;
- (IBAction)performTransaction:(UIButton *)sender;

@end

@implementation CalculatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.displayLabel.text = @"0";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Handlers

- (IBAction)operandTapped:(UIButton *)sender
{
    if (!self.brain)
    {
        self.brain = [[CalculatorBrain alloc] init];
    }
    
    // returns value to be displayed, so update the displayLabel
    self.displayLabel.text = [self.brain addOperandDigit:sender.titleLabel.text];
}

- (IBAction)operatorTapped:(UIButton *)sender
{
    if (!self.brain)
    {
        self.displayLabel.text = @"Enter operand value";
    }
    else
    {
        NSString *displayValue = [self.brain addOperator:sender.titleLabel.text];
        if (displayValue)
        {
            self.displayLabel.text = displayValue;
        }
    }
}

- (void)clearTransaction:(UIButton *)sender
{
    self.brain = nil;
    self.displayLabel.text = @"0";
}

- (void)performTransaction:(UIButton *)sender
{
    if (self.brain)
    {
        NSString *displayValue = [self.brain performCalculationIfPossible];
        if (displayValue)
        {
            self.displayLabel.text = displayValue;
            self.brain = nil;
        }
    }
}

@end