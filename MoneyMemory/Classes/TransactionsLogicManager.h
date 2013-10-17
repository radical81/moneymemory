//
//  TransactionsLogicManager.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryDomainObject.h"

@interface TransactionsLogicManager : NSObject

-(void) createCategory:(int)_id limit:(double) _limit name: (NSString*) _name;
-(void) createTransaction:(int) _id amount: (double) _amount timestamp:(int) _timestamp currency: (NSString*) _currency is_a:(CategoryDomainObject*) _is_a;

@end
