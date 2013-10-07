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

-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount {
    Transaction* newTransaction = [NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:moc];
    newTransaction.id = [NSNumber numberWithInt:_id];
    newTransaction.amount = [NSNumber numberWithDouble:_amount];
    NSTimeInterval interval = [[NSDate date]timeIntervalSince1970];
    NSInteger timeInt = interval;
    newTransaction.timestamp = [NSNumber numberWithInt:timeInt];
    
    
    NSError* error = nil;
    if (![moc save:&error]){
        NSLog(@"Error in CoreData Save: %@", [error localizedDescription]);
    }
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
