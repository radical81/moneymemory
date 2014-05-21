//
//  SpendMoneyViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/12/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "SpendMoneyViewController.h"

@interface SpendMoneyViewController ()

@end

@implementation SpendMoneyViewController {
    NSString* currencySelected;
}

@synthesize transactionCategory;
@synthesize transactionType = _transactionType;
@synthesize transactionCategoryText;
@synthesize amountTextField = _amountTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_transactionType setText:transactionCategoryText];
    currencies = [[NSArray alloc] initWithObjects:@"SGD", @"PHP", @"USD", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) hideKeyboard:(id)sender {
    [_amountTextField resignFirstResponder];
}

- (void)dealloc {
    if(currencies) {
        [currencies release];
        currencies = nil;
    }
    [_transactionType release];
    [_amountTextField release];
    [super dealloc];
}

//Picker view for currency

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [currencies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [currencies objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currencySelected = [currencies objectAtIndex:row];
    NSLog(@"Currency selected: %@", currencySelected);
}

@end
