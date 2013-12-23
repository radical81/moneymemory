//
//  TransactionsLogicManager.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryDomainObject.h"
#import "TransactionDomainObject.h"

@interface TransactionsLogicManager : NSObject

-(CategoryDomainObject*) generateCategoryDomainObject:(int)_id limit:(double) _limit name: (NSString*) _name;
-(TransactionDomainObject*) generateTransactionDomainObject:(int) _id amount: (double) _amount timestamp:(int) _timestamp currency: (NSString*) _currency is_a:(CategoryDomainObject*) _is_a;
-(CategoryDomainObject*) fetchCategoryWithId: (int) _id;
-(NSArray*) fetchAllCategories;
-(TransactionDomainObject*)fetchTransactionWithId: (int) _id;
-(NSArray*) fetchAllTransactions;
-(void) saveCategoryToCoreData:(CategoryDomainObject*) categoryDomainObject;
-(void) saveTransactionToCoreData:(TransactionDomainObject*) transactionDomainObject withCategory:(CategoryDomainObject*) categoryDomainObject;
@end
