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
