//
//  RunTestCoreData
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "RunTestCoreData.h"
#import "CoreDataManager.h"
#import "Transaction.h"

@implementation RunTestCoreData

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

-(void) runTestData {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    
    
    NSArray* firstResult = [coreDataManager fetchAllTransactions:managedObjectContext];
    NSLog(@"First Result Count: %d", [firstResult count]);
        
    ////Saving
    int categoryId = 4;
    double limit = 100;
    NSString* categoryName = @"Test Category For Edit";
    int transactionId = 6;
    double transactionAmount = 8.5;
    NSString* transactionCurrency = @"SGD";
    
    [coreDataManager insertCategory:managedObjectContext id:categoryId limit:limit name:categoryName];
    
    
    [coreDataManager insertTransaction:managedObjectContext id:transactionId amount:transactionAmount currency: transactionCurrency categoryId:categoryId];
        
    
    NSError* error = nil;
    if (![managedObjectContext save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
    
    ////Results after saving
    NSArray* secondResults= [coreDataManager fetchAllTransactions:managedObjectContext];
    NSLog(@"Seconds Result Count: %d", [secondResults count]);
    NSLog(@"Transactions with category %d: %@", categoryId, [coreDataManager fetchTransactionIsA:categoryId context:managedObjectContext]);
    
    //Update transaction with Peso
    [coreDataManager updateTransactionWithId:transactionId newAmount:400 currency:@"PHP" context:managedObjectContext];
    
    //Results after deleting
    NSArray* thirdResults= [coreDataManager fetchAllTransactions:managedObjectContext];
    NSLog(@"Third Result Count: %d", [thirdResults count]);
    NSLog(@"Transactions with category %d: %@", categoryId, [coreDataManager fetchTransactionIsA:categoryId context:managedObjectContext]);
    
    [coreDataManager release];
    
    
}

@end
