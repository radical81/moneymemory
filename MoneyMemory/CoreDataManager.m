//
//  CoreDataManager.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "Transaction.h"

@implementation CoreDataManager

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
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
}

-(void) run: (NSManagedObjectContext*) moc{
    
    
    
    NSArray* firstResult = [self fetchAllTransactions:moc];
    NSLog(@"First Result Count: %d", [firstResult count]);
    
    
    ////Saving
    Transaction* firstTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
    firstTransaction.id = [NSNumber numberWithInt:1];
    firstTransaction.amount = [NSNumber numberWithDouble:2.5];
    NSTimeInterval interval = [[NSDate date]timeIntervalSince1970];
    NSInteger timeInt = interval;
    firstTransaction.timestamp = [NSNumber numberWithInt:timeInt];
    
    
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
    
    ////Results after saving
    NSArray* secondResults= [self fetchAllTransactions:moc];
    NSLog(@"Seconds Result Count: %d", [secondResults count]);
    
    
    
}


-(NSArray*) fetchAllTransactions: (NSManagedObjectContext*) moc{
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSEntityDescription *transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    
    NSArray* resultsArray = [moc executeFetchRequest:request error:nil];
    for (Transaction* transaction in resultsArray){
        NSLog(@"Transaction %@ is %@:",transaction.id,transaction.amount);
    }
    
    return resultsArray;
}

@end
