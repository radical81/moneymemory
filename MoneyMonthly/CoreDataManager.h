//
//  CoreDataManager.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"
#import "Transaction.h"
#import "Income.h"

@interface CoreDataManager : NSObject

-(void) insertCategory: (NSManagedObjectContext*)moc id: (int) _id limit: (double)_limit name: (NSString*) _name;
-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount categoryId: (int) _categoryId timeStamp: (int) _timeStamp imagepath: (NSString*) _imagepath comment: (NSString*) _comment;
-(NSArray*) fetchAllCategories: (NSManagedObjectContext*)moc;
-(NSArray*) fetchAllTransactions: (NSManagedObjectContext*) moc limit: (int) limit;
-(NSArray*)fetchTransactionIsA: (int) categoryId context: (NSManagedObjectContext*) moc limit: (int) limit;
-(Category*)fetchCategoryWithId: (int) _id context: (NSManagedObjectContext*) moc;
-(Transaction*)fetchTransactionWithId: (int) _id context: (NSManagedObjectContext*) moc;
-(void) updateCategoryWithId:(int) _id newLimit: (double) _newLimit newName: (NSString*) _newName context: (NSManagedObjectContext*) moc;
-(void) updateTransactionWithId: (int) _id newAmount: (double) _newAmount newTimeStamp: (int) _newTimeStamp newImagePath: (NSString*) _newImagePath newComment: (NSString*) _newComment context: (NSManagedObjectContext*) moc;
-(void) deleteTransactionWithId:(int)_id context:(NSManagedObjectContext*)moc;
-(void) deleteCategoryWithId:(int)_id context:(NSManagedObjectContext*)moc;
-(Transaction*) retrieveTransactionWithMaxId: (NSManagedObjectContext*) moc;
-(Category*) retrieveCategoryWithMaxId: (NSManagedObjectContext*) moc;
- (NSArray*) fetchIncomeMonthly: (NSManagedObjectContext*) moc;
-(void) updateIncomeMonthly: (NSManagedObjectContext*) moc amount: (double) _amount effective: (double) timeStamp;
-(Income*) retrieveIncome: (NSManagedObjectContext*) moc effective: (double) timeStamp;
-(NSArray*) fetchTimeStamps: (NSManagedObjectContext*) moc;

@end
