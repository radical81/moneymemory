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

-(TransactionDomainObject*) generateTransactionDomainObject:(int) _id amount: (double) _amount timestamp:(int) _timestamp imagepath: (NSString*) _imagepath comment: (NSString*) _comment is_a:(CategoryDomainObject*) _is_a;
-(CategoryDomainObject*) fetchCategoryWithId: (int) _id;
-(NSArray*) fetchAllCategories;
-(NSArray*) fetchCurrentCategories;
-(NSArray*) fetchCategoryNames;
-(TransactionDomainObject*)fetchTransactionWithId: (int) _id;
-(NSArray*) fetchAllTransactions:(int) limit;
-(NSArray*) fetchTransactionsWithinMonth: (NSDate*) givenDate limit: (int) limit;
-(NSArray*) retrieveTotalsForEachCategory: (NSDate*) givenDate;
-(NSNumber*) calculateTotalForMonth: (NSDate*) givenDate;
-(NSNumber*) calculateTotalForCategory: (int) categoryId _givenDate:(NSDate*) givenDate;
-(NSNumber*) calculateTotalOfCategories;
-(NSArray*)fetchTransactionIsA: (int) categoryId limit: (int) limit;
-(void) saveCategoryToCoreData:(CategoryDomainObject*) categoryDomainObject;
-(void) updateTransaction:(TransactionDomainObject*) transactionDomainObject;
-(void) deleteTransaction:(TransactionDomainObject*) transactionDomainObject;
-(void) updateCategory:(CategoryDomainObject*) categoryDomainObject;
-(void) deleteCategoryInCoreData:(CategoryDomainObject*) categoryDomainObject;
-(void) saveTransactionToCoreData:(TransactionDomainObject*) transactionDomainObject withCategory:(CategoryDomainObject*) categoryDomainObject;
-(int) retrieveLatestTransactionId;
-(int) retrieveLatestCategoryId;
-(NSArray*) retrieveIncomeHistory;
-(void) updateIncomeMonthly: (double) amount;
-(void) updateIncomeMonthly: (double) amount effective:(double) timeStamp;
-(double) retrieveIncomeMonthly;
-(double) retrieveIncomeMonthly :(double) timeStamp;
-(NSArray*) fetchTimeStamps;
-(NSDate*) fetchIncomeMinDate;
-(NSDate*) fetchIncomeMaxDate;

@end
