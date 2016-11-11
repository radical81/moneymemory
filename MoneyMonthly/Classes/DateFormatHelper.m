//
//  DateFormatHelper.m
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 9/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "DateFormatHelper.h"

@implementation DateFormatHelper

-(NSString*) stringMonthYear:(NSDate*) date {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM YYYY"];
    NSString* monthYear = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return monthYear;
}

-(NSDate*) dateFromDayMonthYear:(NSString*) dateString {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    NSDate* dayMonthYear = [dateFormatter dateFromString:dateString];
    [dateFormatter release];
    return dayMonthYear;
}

@end
