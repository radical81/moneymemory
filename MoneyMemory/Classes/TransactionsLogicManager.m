//
//  TransactionsLogicManager.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "TransactionsLogicManager.h"
#import "CoreDataManager.h"

@implementation TransactionsLogicManager {
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
}

- (void) initCoreData
{
    NSError *error;
    
    // Path to sqlite file.
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/moneymanager.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // Init the model, coordinator, context
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
        NSLog(@"Error: %@", [error localizedFailureReason]);
    else
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
}

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

-(void) saveCategoryToCoreData:(CategoryDomainObject*) categoryDomainObject {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    int categoryId = [categoryDomainObject.id intValue];
    double limit = [categoryDomainObject.limit doubleValue];
    NSString* categoryName = categoryDomainObject.name;
    [coreDataManager insertCategory:managedObjectContext id:categoryId limit:limit name:categoryName];
    [coreDataManager release];
}

-(void) saveTransactionToCoreData:(TransactionDomainObject*) transactionDomainObject withCategory:(CategoryDomainObject*) categoryDomainObject {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    int categoryId = [categoryDomainObject.id intValue];
    int transactionId = [transactionDomainObject.id intValue];
    double transactionAmount = [transactionDomainObject.amount doubleValue];
    NSString* transactionCurrency = transactionDomainObject.currency;
    [coreDataManager insertTransaction:managedObjectContext id:transactionId amount:transactionAmount currency: transactionCurrency categoryId:categoryId];
    [coreDataManager release];
}

@end
