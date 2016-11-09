//
//  DateFormatHelper.m
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 9/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "DateFormatHelper.h"

@implementation DateFormatHelper

-(NSString*) stringFromMonthYear:(NSDate*) date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM YYYY"];
    NSString* monthYear = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return monthYear;
}

@end
