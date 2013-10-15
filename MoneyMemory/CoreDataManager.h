//
//  CoreDataManager.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreDataManager : NSObject

-(void) insertCategory: (NSManagedObjectContext*)moc id: (int) _id limit: (double)_limit name: (NSString*) _name;
-(void) insertTransaction: (NSManagedObjectContext*) moc id: (int) _id amount: (double) _amount categoryId: (int) _categoryId;
-(NSArray*) fetchAllCategories: (NSManagedObjectContext*)moc;
-(NSArray*) fetchAllTransactions: (NSManagedObjectContext*) moc;

@end
