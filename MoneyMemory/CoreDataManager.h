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

@interface CoreDataManager : NSObject

-(void) insertCategory: (NSManagedObjectContext*)moc id: (int) _id limit: (double)_limit name: (NSString*) _name;
-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount currency:(NSString*)_currency categoryId: (int) _categoryId;
-(NSArray*) fetchAllCategories: (NSManagedObjectContext*)moc;
-(NSArray*) fetchAllTransactions: (NSManagedObjectContext*) moc;
-(NSArray*)fetchTransactionIsA: (int) categoryId context: (NSManagedObjectContext*) moc;
-(Category*)fetchCategoryWithId: (int) _id context: (NSManagedObjectContext*) moc;
-(Transaction*)fetchTransactionWithId: (int) _id context: (NSManagedObjectContext*) moc;
-(void) updateCategoryWithId:(int) _id newLimit: (double) _newLimit newName: (NSString*) _newName context: (NSManagedObjectContext*) moc;
-(void) updateTransactionWithId: (int) _id newAmount: (double) _newAmount currency: (NSString*) _currency context: (NSManagedObjectContext*) moc;
-(void) deleteTransactionWithId:(int)_id context:(NSManagedObjectContext*)moc;
-(void) deleteCategoryWithId:(int)_id context:(NSManagedObjectContext*)moc;
-(Transaction*) retrieveTransactionWithMaxId: (NSManagedObjectContext*) moc;
-(Category*) retrieveCategoryWithMaxId: (NSManagedObjectContext*) moc;
@end
