//
//  TransactionsLogicManager.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "TransactionsLogicManager.h"
#import "CoreDataManager.h"
#import "Transaction.h"
#import "Category.h"
#import "Income.h"

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

-(CategoryDomainObject*) generateCategoryDomainObjectFromCategory:(Category*) category {
    CategoryDomainObject* categoryDomainObject = [[[CategoryDomainObject alloc]init]autorelease];
    categoryDomainObject.id = [category valueForKey:@"id"];
    categoryDomainObject.limit = [category valueForKey:@"limit"];
    categoryDomainObject.name = [category valueForKey:@"name"];

    return categoryDomainObject;
}

-(TransactionDomainObject*) generateTransactionDomainObject:(int) _id amount: (double) _amount timestamp:(int) _timestamp imagepath: (NSString*) _imagepath comment: (NSString*) _comment is_a:(CategoryDomainObject*) _is_a {
    TransactionDomainObject* transaction = [[[TransactionDomainObject alloc]init]autorelease];
    transaction.id = [NSNumber numberWithInt:_id];
    transaction.amount = [NSNumber numberWithDouble:_amount];
    transaction.timestamp = [NSNumber numberWithInt:_timestamp];
    transaction.imagepath = _imagepath;
    transaction.comment = _comment;
    transaction.is_a = _is_a;
    return  transaction;
}

-(CategoryDomainObject*) fetchCategoryWithId: (int) _id {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    
    Category* category = [coreDataManager fetchCategoryWithId:_id context:managedObjectContext];
    [coreDataManager release];
    CategoryDomainObject* categoryDomainObject = [[[CategoryDomainObject alloc]init]autorelease];
    if(![category isKindOfClass:[NSNull class]]) {
        categoryDomainObject.id = [category valueForKey:@"id"];
        categoryDomainObject.limit = [category valueForKey:@"limit"];
        categoryDomainObject.name = [category valueForKey:@"name"];
    }
    return categoryDomainObject;
}

-(NSArray*) fetchAllCategories {
    NSMutableArray* allCategories = [[[NSMutableArray alloc]init]autorelease];
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    NSArray* categories = [coreDataManager fetchAllCategories:managedObjectContext];
    for(Category* category in categories) {
        CategoryDomainObject* categoryDomainObject = [self generateCategoryDomainObjectFromCategory:category];
        [allCategories addObject:categoryDomainObject];
    }
    [coreDataManager release];
    
    return allCategories;
}

-(NSArray*) fetchCategoryNames {
    NSMutableArray* categoryNames = [[[NSMutableArray alloc]init]autorelease];
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    NSArray* categories = [coreDataManager fetchAllCategories:managedObjectContext];
    for(Category* category in categories) {
        [categoryNames addObject:[category valueForKey:@"name"]];
    }
    [coreDataManager release];
    return categoryNames;
}

-(TransactionDomainObject*)fetchTransactionWithId: (int) _id {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    
    Transaction* transaction = [coreDataManager fetchTransactionWithId:_id context:managedObjectContext];
    [coreDataManager release];
    TransactionDomainObject* transactionDomainObject = [[[TransactionDomainObject alloc]init
                                                         ]autorelease];
    if(![transaction isKindOfClass:[NSNull class]]) {
        transactionDomainObject.id = [transaction valueForKey:@"id"];
        transactionDomainObject.amount = [transaction valueForKey:@"amount"];
        transactionDomainObject.timestamp = [transaction valueForKey:@"timestamp"];
        transactionDomainObject.imagepath = [transaction valueForKey:@"imagepath"];
        transactionDomainObject.comment = [transaction valueForKey:@"comment"];
        transactionDomainObject.is_a = [transaction valueForKey:@"is_a"];
    }
    return transactionDomainObject;
}

-(NSArray*) fetchAllTransactions:(int) limit {
    NSMutableArray* allTransactions = [[[NSMutableArray alloc]init]autorelease];
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    NSArray* transactions = [coreDataManager fetchAllTransactions:managedObjectContext limit:limit];
    for(Transaction* transaction in transactions) {
        TransactionDomainObject* transactionDomainObject = [[TransactionDomainObject alloc]init];
        [transactionDomainObject resetValues];
        transactionDomainObject.id = [transaction valueForKey:@"id"];
        transactionDomainObject.amount = [transaction valueForKey:@"amount"];
        transactionDomainObject.timestamp = [transaction valueForKey:@"timestamp"];
        transactionDomainObject.imagepath = [transaction valueForKey:@"imagepath"];
        transactionDomainObject.comment = [transaction valueForKey:@"comment"];
        transactionDomainObject.is_a = [transaction valueForKey:@"is_a"];
        [allTransactions addObject:transactionDomainObject];
        [transactionDomainObject release];
    }
    [coreDataManager release];
    return allTransactions;
}

-(NSNumber*) calculateTotalForCategory: (int) categoryId {
    NSLog(@"calculateTotalForCategory %d", categoryId);
    double total = 0;
    NSArray* transactions = [self fetchTransactionIsA:categoryId limit:0];
    for(TransactionDomainObject* transaction in transactions) {
        NSLog(@"Add %@ with id %@", transaction.amount, transaction.id);
        total += [transaction.amount doubleValue];
    }
    return [NSNumber numberWithDouble:total];
}

-(NSNumber*) calculateTotalOfCategories {
    NSLog(@"calculateTotalOfCategories");
    double total = 0;
    NSArray* categories = [self fetchAllCategories];
    for(CategoryDomainObject* category in categories) {
        NSLog(@"Add %@ with id %@", category.limit, category.id);
        total += [category.limit doubleValue];
    }
    NSLog(@"%f", total);
    return [NSNumber numberWithDouble:total];
}


-(NSArray*)fetchTransactionIsA: (int) categoryId limit: (int) limit {
    NSMutableArray* allTransactions = [[[NSMutableArray alloc]init]autorelease];
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    NSArray* transactions = [coreDataManager fetchTransactionIsA:categoryId context:managedObjectContext limit:limit];
    for(Transaction* transaction in transactions) {
        TransactionDomainObject* transactionDomainObject = [[TransactionDomainObject alloc]init];
        [transactionDomainObject resetValues];
        transactionDomainObject.id = [transaction valueForKey:@"id"];
        transactionDomainObject.amount = [transaction valueForKey:@"amount"];
        transactionDomainObject.timestamp = [transaction valueForKey:@"timestamp"];
        transactionDomainObject.imagepath = [transaction valueForKey:@"imagepath"];
        transactionDomainObject.comment = [transaction valueForKey:@"comment"];
        transactionDomainObject.is_a = [transaction valueForKey:@"is_a"];
        NSLog(@"Fetched transaction with id %@ amount %@ and date %@ and comment %@", transactionDomainObject.id, transactionDomainObject.amount, transactionDomainObject.timestamp, transactionDomainObject.comment);
        [allTransactions addObject:transactionDomainObject];
        [transactionDomainObject release];
    }
    [coreDataManager release];
    return allTransactions;
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

-(void) deleteCategoryInCoreData:(CategoryDomainObject*) categoryDomainObject {
    NSLog(@"deleteCategoryInCoreData...");
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    int categoryId = [categoryDomainObject.id intValue];
    NSLog(@"Deleting category with id %d", categoryId);
    [coreDataManager deleteCategoryWithId:categoryId context: managedObjectContext];
    [coreDataManager release];
}

-(void) saveTransactionToCoreData:(TransactionDomainObject*) transactionDomainObject withCategory:(CategoryDomainObject*) categoryDomainObject {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    int categoryId = [categoryDomainObject.id intValue];
    int transactionId = [transactionDomainObject.id intValue];
    int timeStamp = [transactionDomainObject.timestamp intValue];
    NSString* imagepath = transactionDomainObject.imagepath;
    NSString* comment = transactionDomainObject.comment;
    double transactionAmount = [transactionDomainObject.amount doubleValue];
    [coreDataManager insertTransaction:managedObjectContext id:transactionId amount:transactionAmount categoryId:categoryId timeStamp:timeStamp imagepath:imagepath comment:comment];
    [coreDataManager release];
}

-(void) updateTransaction:(TransactionDomainObject*) transactionDomainObject {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    int transactionId = [transactionDomainObject.id intValue];
    int timeStamp = [transactionDomainObject.timestamp intValue];
    NSString* imagepath = transactionDomainObject.imagepath;
    NSString* comment = transactionDomainObject.comment;
    double transactionAmount = [transactionDomainObject.amount doubleValue];

    [coreDataManager updateTransactionWithId: transactionId newAmount: transactionAmount newTimeStamp: timeStamp newImagePath: imagepath newComment: comment context: managedObjectContext];
    [coreDataManager release];
}

-(void) deleteTransaction:(TransactionDomainObject*) transactionDomainObject {
    NSLog(@"deleteTransaction...");
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    int transactionId = [transactionDomainObject.id intValue];
    NSLog(@"Deleting Transaction with id %d", transactionId);
    [coreDataManager deleteTransactionWithId:transactionId context: managedObjectContext];
    [coreDataManager release];
}

-(int) retrieveLatestTransactionId {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    Transaction* lastTransaction = [coreDataManager retrieveTransactionWithMaxId:managedObjectContext];
    NSLog(@"retrieveLatestTransactionId, %d", [lastTransaction.id intValue]);
    return [lastTransaction.id intValue];
}

-(int) retrieveLatestCategoryId {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    Category* lastCategory = [coreDataManager retrieveCategoryWithMaxId:managedObjectContext];
    NSLog(@"retrieveLatestCategoryId, %d", [lastCategory.id intValue]);
    return [lastCategory.id intValue];
}

-(void) updateIncomeMonthly: (double) amount {
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    [coreDataManager updateIncomeMonthly:managedObjectContext amount:amount];
    NSLog(@"updateIncomeMonthly %f",amount);
}

-(double) retrieveIncomeMonthly {
    NSLog(@"retrieveIncomeMonthly...");
    CoreDataManager* coreDataManager = [[CoreDataManager alloc]init];
    [self initCoreData];
    Income* income = [coreDataManager retrieveIncomeWithMaxId:managedObjectContext];
    return [income.monthly doubleValue];
}

@end
