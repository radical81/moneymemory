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

-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount categoryId: (int) _categoryId {
    Transaction* newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
    newTransaction.id = [NSNumber numberWithInt:_id];
    newTransaction.amount = [NSNumber numberWithDouble:_amount];
    Category* whichCategory = [self fetchCategoryWithId:_categoryId context:moc];
    newTransaction.is_a = whichCategory;
    NSTimeInterval interval = [[NSDate date]timeIntervalSince1970];
    NSInteger timeInt = interval;
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
    return [resultTransaction objectAtIndex:0];
}

-(Category*)fetchCategoryWithId: (int) _id context: (NSManagedObjectContext*) moc  {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription* categoryEntity = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc];
    [request setEntity:categoryEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"id = %@",[NSNumber numberWithInt:_id]]];
    NSArray* resultCategory = [moc executeFetchRequest:request error:nil];
    [request release];
    return [resultCategory objectAtIndex:0];
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

@end
