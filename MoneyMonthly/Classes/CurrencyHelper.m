//
//  CurrencyHelper.m
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 9/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "CurrencyHelper.h"

@implementation CurrencyHelper

-(NSString*) numberWithComma:(NSNumber*) num {    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:2];
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    formatter.groupingSize = 3;
    NSString* numString = [formatter stringFromNumber:num];
    [formatter release];
    return numString;
}

@end
