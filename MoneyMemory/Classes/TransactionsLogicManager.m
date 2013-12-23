//
//  TransactionsLogicManager.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "TransactionsLogicManager.h"

@implementation TransactionsLogicManager

-(CategoryDomainObject*) generateCategoryDomainObject:(int)_id limit:(double) _limit name: (NSString*) _name {
    CategoryDomainObject* category = [[[CategoryDomainObject alloc]init]autorelease];
    category.id = [NSNumber numberWithInt:_id];
    category.limit = [NSNumber numberWithDouble:_limit];
    category.name = _name;
    return  category;
}

-(TransactionDomainObject*) generateTransactionDomainObject:(int) _id amount: (double) _amount timestamp:(int) _timestamp currency: (NSString*) _currency is_a:(CategoryDomainObject*) _is_a {
    TransactionDomainObject* transaction = [[[TransactionDomainObject alloc]init]autorelease];
    transaction.id = [NSNumber numberWithInt:_id];
    transaction.amount = [NSNumber numberWithDouble:_amount];
    transaction.timestamp = [NSNumber numberWithInt:_timestamp];
    transaction.currency = _currency;
    transaction.is_a = _is_a;
    return  transaction;
}

@end
