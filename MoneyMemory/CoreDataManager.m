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

-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount categoryId: (int) _categoryId timeStamp: (int) _timeStamp imagepath: (NSString*) imagepath {
    Transaction* newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
    newTransaction.id = [NSNumber numberWithInt:_id];
    newTransaction.amount = [NSNumber numberWithDouble:_amount];
    Category* whichCategory = [self fetchCategoryWithId:_categoryId context:moc];
    newTransaction.is_a = whichCategory;
    newTransaction.timestamp = [NSNumber numberWithInt:_timeStamp];
    newTransaction.imagepath = imagepath;
    
    
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

-(NSArray*)fetchTransactionIsA: (int) categoryId context: (NSManagedObjectContext*) moc limit: (int) limit{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    if(limit > 0) {
        [request setFetchLimit: limit];
    }
    NSEntityDescription* transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"is_a.id = %@", [NSNumber numberWithInt:categoryId]]];
    NSArray* resultTransaction = [moc executeFetchRequest:request error:nil];
    [request release];
    return resultTransaction;
}

-(Category*)fetchCategoryWithId: (int) _id context: (NSManagedObjectContext*) moc  {
    NSLog(@"Coredata fetchCategoryWithId...");
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* categoryEntity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc];
    [request setEntity:categoryEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id = %@",[NSNumber numberWithInt:_id]]];
    NSArray* resultCategory = [moc executeFetchRequest:request error:nil];
    [request release];
    Category* resultSingle = [resultCategory objectAtIndex:0];
    NSLog(@"Single Category %@ named %@ with limit %@", resultSingle.id, resultSingle.name, resultSingle.limit);
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

-(NSArray*) fetchAllTransactions: (NSManagedObjectContext*) moc limit: (int) limit {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [sortDescriptor release];
    [request setSortDescriptors:sortDescriptors];
    [request setFetchLimit:limit];
    
    NSEntityDescription *transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    
    NSArray* resultsArray = [moc executeFetchRequest:request error:nil];
    [request release];
    for (Transaction* transaction in resultsArray){
        NSLog(@"Transaction with id %@ saved on %@ under category %@ is %@ with image %@:",transaction.id,transaction.timestamp,transaction.is_a.id,transaction.amount, transaction.imagepath);
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

-(void) updateTransactionWithId: (int) _id newAmount: (double) _newAmount context: (NSManagedObjectContext*) moc {
    Transaction* transactionToUpdate = [self fetchTransactionWithId:_id context:moc];
    transactionToUpdate.amount = [NSNumber numberWithDouble:_newAmount];
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
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Delete: %@", [error localizedDescription]);
    }
}

-(void) deleteCategoryWithId:(int)_id context:(NSManagedObjectContext*)moc {
    NSLog(@"Coredata deleteCategoryWithId...");
    NSArray* transactionsInCategory = [self fetchTransactionIsA:_id context:moc];
    for(Transaction* transaction in transactionsInCategory) {
        NSLog(@"Found deletable transaction");
        [self deleteTransactionWithId:[transaction.id intValue]  context:moc];
    }
    Category* categoryToDelete = [self fetchCategoryWithId:_id context:moc];
    if(categoryToDelete != NULL) {
        NSLog(@"Found deletable category");
    }
    [moc deleteObject:categoryToDelete];
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Delete: %@", [error localizedDescription]);
    }

}

-(Category*) retrieveCategoryWithMaxId: (NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Category"];
    
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    
    NSError *error = nil;
    
    Category* category = [moc executeFetchRequest:request error:&error].lastObject;

    return category;
}

-(void) insertIncomeMonthly: (NSManagedObjectContext*) moc amount: (double) _amount {
    Income*  income = [NSEntityDescription insertNewObjectForEntityForName:@"Income" inManagedObjectContext:moc];
    income.monthly = [NSNumber numberWithDouble:_amount];
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
}

-(void) updateIncomeMonthly: (NSManagedObjectContext*) moc amount: (double) _amount {
    Income* income = [self retrieveIncomeWithMaxId:moc];
    if(income == nil) {
        NSLog(@"Setting income for the first time...");
        [self insertIncomeMonthly:moc amount:_amount];
    }
    else {
        NSLog(@"Updating income...");
        income.monthly = [NSNumber numberWithDouble:_amount];
        NSError* error = nil;
        if (![moc save:&error]){
            NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
        }
    }
}

-(Income*) retrieveIncomeWithMaxId: (NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Income"];
    
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    
    NSError *error = nil;
    
    Income* income = [moc executeFetchRequest:request error:&error].lastObject;
    
    return income;
}




@end