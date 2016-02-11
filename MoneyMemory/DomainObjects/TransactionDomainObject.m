//
//  TransactionDomainObject.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "TransactionDomainObject.h"

@implementation TransactionDomainObject

@synthesize id;
@synthesize amount;
@synthesize timestamp;
@synthesize imagepath;
@synthesize is_a;

-(void) resetValues {
    self.id = nil;
    self.amount = nil;
    self.timestamp = nil;
    self.imagepath = nil;
    self.is_a = nil;
}

@end
