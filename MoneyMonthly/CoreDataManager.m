//
//  CoreDataManager.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "CurrencyHelper.h"
#import "DateFormatHelper.h"

@interface CoreDataManager()

@property(nonatomic, retain) DateFormatHelper* dateHelper;

@end

@implementation CoreDataManager

@synthesize dateHelper = _dateHelper;

-(id) init {
    self = [super init];
    if(self) {
        _dateHelper = [[DateFormatHelper alloc]init];
    }
    return self;
}

- (void) dealloc {
    [_dateHelper release];
    [super dealloc];
}

-(void) insertCategory: (NSManagedObjectContext*)moc id: (int) _id limit: (double)_limit name: (NSString*) _name {
    Category* newCategory = [NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:moc];
    newCategory.id = [NSNumber numberWithInt:_id];
    newCategory.limit = [NSNumber numberWithDouble:_limit];
    newCategory.name = _name;
    newCategory.visible = YES;
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
}

-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount categoryId: (int) _categoryId timeStamp: (int) _timeStamp imagepath: (NSString*) _imagepath comment: (NSString*) _comment {
    Transaction* newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
    newTransaction.id = [NSNumber numberWithInt:_id];
    newTransaction.amount = [NSNumber numberWithDouble:_amount];
    Category* whichCategory = [self fetchCategoryWithId:_categoryId context:moc];
    newTransaction.is_a = whichCategory;
    newTransaction.timestamp = [NSNumber numberWithInt:_timeStamp];
    newTransaction.imagepath = _imagepath;
    newTransaction.comment = _comment;
    
    
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
    NSLog(@"fetchTransactionIsA");
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    if(limit > 0) {
        [request setFetchLimit: limit];
    }
    NSEntityDescription* transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"is_a.id = %@", [NSNumber numberWithInt:categoryId]]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
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
        NSLog(@"Transaction with id %@ saved on %@ under category %@ is %@ with image %@ and comment %@:",transaction.id,transaction.timestamp,transaction.is_a.id,transaction.amount, transaction.imagepath, transaction.comment);
    }
    
    return resultsArray;
}

-(void) updateCategoryWithId:(int) _id newLimit: (double) _newLimit newName: (NSString*) _newName visible: (BOOL)_visible context: (NSManagedObjectContext*) moc {
    Category* categoryToUpdate = [self fetchCategoryWithId:_id context:moc];
    categoryToUpdate.limit = [NSNumber numberWithDouble:_newLimit];
    categoryToUpdate.name = _newName;
    categoryToUpdate.visible = _visible;
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
    else {
        NSLog(@"Saved category %@ with limit %f", _newName, _newLimit);
    }
}

-(void) updateTransactionWithId: (int) _id newAmount: (double) _newAmount newTimeStamp: (int) _newTimeStamp newImagePath: (NSString*) _newImagePath newComment: (NSString*) _newComment context: (NSManagedObjectContext*) moc {
    Transaction* transactionToUpdate = [self fetchTransactionWithId:_id context:moc];
    transactionToUpdate.amount = [NSNumber numberWithDouble:_newAmount];
    transactionToUpdate.timestamp = [NSNumber numberWithInt:_newTimeStamp];
    transactionToUpdate.imagepath = _newImagePath;
    transactionToUpdate.comment = _newComment;
    
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
    NSArray* transactionsInCategory = [self fetchTransactionIsA:_id context:moc limit:0];
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

-(Income*) retrieveLatestIncome: (NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Income"];
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO]];
    NSError *error = nil;
    Income* income = [moc executeFetchRequest:request error:&error].lastObject;
    NSLog(@"Latest Income: %@", income.monthly);
    return income;
}

- (NSArray*) fetchIncomeMonthly: (NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Income"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"effective" ascending:NO]];
    NSError *error = nil;
    NSArray* resultsArray = [moc executeFetchRequest:request error:&error];
    [request release];
    NSMutableArray* incomeArray = [[[NSMutableArray alloc]init]autorelease];
    CurrencyHelper* helper = [[CurrencyHelper alloc]init];

    for (Income* income in resultsArray){
        NSLog(@"Income with id %@ amount %@ effective on %@", income.id, income.monthly, income.effective);
        NSDate* incomeDate = [NSDate dateWithTimeIntervalSince1970:[income.effective doubleValue]];
        NSString* monthYear = [_dateHelper stringMonthYear:incomeDate];
        [incomeArray addObject: [NSString stringWithFormat:@"$ %@ (%@)", [helper numberWithComma: income.monthly], monthYear]];
    }
    [helper release];
    NSLog(@"Monthly income history: %@", incomeArray);
    return [incomeArray copy];
}

-(NSString*) fetchIncomeMonthMin:(NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Income"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"effective" ascending:YES]];
    request.fetchLimit = 1;
    NSError *error = nil;
    Income* income = [moc executeFetchRequest:request error:&error].lastObject;
    [request release];
    NSDate* incomeDate = [NSDate dateWithTimeIntervalSince1970:[income.effective doubleValue]];
    
    return [_dateHelper stringMonthYear:incomeDate];
}

-(NSString*) fetchIncomeMonthMax:(NSManagedObjectContext*) moc {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Income"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"effective" ascending:NO]];
    request.fetchLimit = 1;
    NSError *error = nil;
    Income* income = [moc executeFetchRequest:request error:&error].lastObject;
    [request release];
    NSDate* incomeDate = [NSDate dateWithTimeIntervalSince1970:[income.effective doubleValue]];

    return [_dateHelper stringMonthYear:incomeDate];
}

-(void) insertIncomeMonthly: (NSManagedObjectContext*) moc amount: (double) _amount effective: (double) timeStamp {
    NSLog(@"insertIncomeMonthly...");
    Income*  income = [NSEntityDescription insertNewObjectForEntityForName:@"Income" inManagedObjectContext:moc];
    int latestIncomeId = [[self retrieveLatestIncome: moc].id intValue];
    latestIncomeId++;
    income.id = [NSNumber numberWithInt:latestIncomeId];
    income.monthly = [NSNumber numberWithDouble:_amount];
    income.effective = [NSNumber numberWithDouble: timeStamp];
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
}



-(void) updateIncomeMonthly: (NSManagedObjectContext*) moc amount: (double) _amount effective: (double) timeStamp {
    NSLog(@"updateIncomeMonthly...");
//    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//    NSDate* newDate = [dateFormatter dateFromString:@"31/10/2016"];
//    timeStamp = [newDate timeIntervalSince1970];
    
    Income* income = [self retrieveLatestIncome:moc];
    if(income == nil) {
        NSLog(@"Setting income for the first time...");
        [self insertIncomeMonthly:moc amount:_amount effective:timeStamp];
        return;
    }
    NSDate* incomeDate = [NSDate dateWithTimeIntervalSince1970:[income.effective doubleValue]];
    NSString* incomeMonthYear = [_dateHelper stringMonthYear:incomeDate];
    NSString* nowMonthYear = [_dateHelper stringMonthYear:[NSDate dateWithTimeIntervalSince1970:timeStamp]];
    NSLog(@"Income Month Year: %@", incomeMonthYear);
    NSLog(@"Now Month Year: %@", nowMonthYear);
    if([incomeMonthYear isEqualToString:nowMonthYear]) {
        NSLog(@"Updating income...");
        income.monthly = [NSNumber numberWithDouble:_amount];
        income.effective = [NSNumber numberWithDouble:timeStamp];
        NSError* error = nil;
        if (![moc save:&error]){
            NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
        }
        return;
    }
    NSLog(@"Add new income for a new month...");
    [self insertIncomeMonthly:moc amount:_amount effective:timeStamp];
}

-(Income*) retrieveIncome: (NSManagedObjectContext*) moc effective: (double) timeStamp {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Income"];
    request.fetchLimit = 1;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"effective" ascending:NO]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"effective <= %@",[NSNumber numberWithDouble:timeStamp]]];
    NSError *error = nil;
    
    Income* income = [moc executeFetchRequest:request error:&error].lastObject;
    
    return income;
}

-(NSArray*) fetchTimeStamps: (NSManagedObjectContext*) moc  {
    NSFetchRequest* request = [[NSFetchRequest alloc]init];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"timestamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [sortDescriptor release];
    [request setSortDescriptors:sortDescriptors];
    
    NSEntityDescription *transactionEntity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:moc];
    [request setEntity:transactionEntity];
    
    NSArray* resultsArray = [moc executeFetchRequest:request error:nil];
    [request release];
    NSMutableArray* timeStampArray = [[[NSMutableArray alloc]init]autorelease];
    for (Transaction* transaction in resultsArray){
        NSLog(@"Transaction with id %@ saved on %@", transaction.id, transaction.timestamp);
        [timeStampArray addObject:transaction.timestamp];
    }
    
    return [timeStampArray copy];
}


@end
