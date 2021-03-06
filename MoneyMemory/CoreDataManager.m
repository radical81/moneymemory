//
//  CoreDataManager.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@implementation CoreDataManager

-(void) insertCategory: (NSManagedObjectContext*)moc id: (int) _id limit: (double)_limit name: (NSString*) _name {
    Category* newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:moc];
    newCategory.id = [NSNumber numberWithInt:_id];
    newCategory.limit = [NSNumber numberWithDouble:_limit];
    newCategory.name = _name;
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
}

-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount currency:(NSString*)_currency categoryId: (int) _categoryId {
    Transaction* newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
    newTransaction.id = [NSNumber numberWithInt:_id];
    newTransaction.amount = [NSNumber numberWithDouble:_amount];
    newTransaction.currency = _currency;
    Category* whichCategory = [self fetchCategoryWithId:_categoryId context:moc];
    newTransaction.is_a = whichCategory;
    NSTimeInterval interval = [[NSDate date]timeIntervalSince1970];
    int timeInt = (int)interval;
    newTransaction.timestamp = [NSNumber numberWithInt:timeInt];
    
    
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
}

-(Transaction*)fetchTransactionWithId: (int) _id context: (NSManagedObjectContext*) moc {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id = %@", [NSNumber numberWithInt:_id]]];
    NSArray* resultTransaction = [moc executeFetchRequest:request error:nil];
    [request release];
    Transaction* resultSingle = [resultTransaction objectAtIndex:0];
    NSLog(@"Transaction with id %@ amount %@ category %@", resultSingle.id, resultSingle.amount, resultSingle.is_a.id);
    return resultSingle;
}

-(NSArray*)fetchTransactionIsA: (int) categoryId context: (NSManagedObjectContext*) moc {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"is_a.id = %@", [NSNumber numberWithInt:categoryId]]];
    NSArray* resultTransaction = [moc executeFetchRequest:request error:nil];
    [request release];
    return resultTransaction;
}

-(Category*)fetchCategoryWithId: (int) _id context: (NSManagedObjectContext*) moc  {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* categoryEntity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc];
    [request setEntity:categoryEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id = %@",[NSNumber numberWithInt:_id]]];
    NSArray* resultCategory = [moc executeFetchRequest:request error:nil];
    [request release];
    Category* resultSingle = [resultCategory objectAtIndex:0];
    NSLog(@"Category %@ named %@ with limit %@", resultSingle.id, resultSingle.name, resultSingle.limit);
    return resultSingle;
}

-(NSArray*) fetchAllCategories: (NSManagedObjectContext*)moc{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* categoryEntity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc];
    [request setEntity:categoryEntity];
    
    NSArray* resultsArray = [moc executeFetchRequest:request error:nil];
    [request release];
    for(Category* cat in resultsArray) {
        NSLog(@"Category %@ named %@ with limit %@", cat.id, cat.name, cat.limit);
    }
    return resultsArray;
}

-(NSArray*) fetchAllTransactions: (NSManagedObjectContext*) moc{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription *transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    
    NSArray* resultsArray = [moc executeFetchRequest:request error:nil];
    [request release];
    for (Transaction* transaction in resultsArray){
        NSLog(@"Transaction %@ under category %@ is %@:",transaction.id,transaction.is_a.id,transaction.amount);
    }
    
    return resultsArray;
}

-(void) updateCategoryWithId:(int) _id newLimit: (double) _newLimit newName: (NSString*) _newName context: (NSManagedObjectContext*) moc {
    Category* categoryToUpdate = [self fetchCategoryWithId:_id context:moc];
    categoryToUpdate.limit = [NSNumber numberWithDouble:_newLimit];
    categoryToUpdate.name = _newName;
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
}

-(void) updateTransactionWithId: (int) _id newAmount: (double) _newAmount currency: (NSString*) _currency context: (NSManagedObjectContext*) moc {
    Transaction* transactionToUpdate = [self fetchTransactionWithId:_id context:moc];
    transactionToUpdate.amount = [NSNumber numberWithDouble:_newAmount];
    transactionToUpdate.currency = _currency;
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
}

-(Transaction*) retrieveTransactionWithMaxId: (NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Transaction"];
    
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    
    NSError *error = nil;
    
    Transaction* transaction = [moc executeFetchRequest:request error:&error].lastObject;
    
    return transaction;
}


-(void) deleteTransactionWithId:(int)_id context:(NSManagedObjectContext*)moc {
    Transaction* transactionToDelete = [self fetchTransactionWithId:_id context:moc];
    [moc deleteObject:transactionToDelete];
}

-(void) deleteCategoryWithId:(int)_id context:(NSManagedObjectContext*)moc {
    NSArray* transactionsInCategory = [self fetchTransactionIsA:_id context:moc];
    for(Transaction* transaction in transactionsInCategory) {
        [moc deleteObject:transaction];
    }
    Category* categoryToDelete = [self fetchCategoryWithId:_id context:moc];
    [moc deleteObject:categoryToDelete];
}

-(Category*) retrieveCategoryWithMaxId: (NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    
    NSError *error = nil;
    
    Category* category = [moc executeFetchRequest:request error:&error].lastObject;

    return category;
}


@end