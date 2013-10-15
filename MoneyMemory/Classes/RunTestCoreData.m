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
    
    NSArray* categories = [coreDataManager fetchAllCategories:managedObjectContext];
    NSLog(@"Categories: %@", categories);
    
    ////Saving
    [coreDataManager insertCategory:managedObjectContext id:1 limit:10 name:@"Test Category"];
    
    
    [coreDataManager insertTransaction:managedObjectContext id:2 amount:5.5 categoryId:1];
        
    
    NSError* error = nil;
    if (![managedObjectContext save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
    
    ////Results after saving
    NSArray* secondResults= [coreDataManager fetchAllTransactions:managedObjectContext];
    NSLog(@"Seconds Result Count: %d", [secondResults count]);
    [coreDataManager release];    
    
    
}

@end
