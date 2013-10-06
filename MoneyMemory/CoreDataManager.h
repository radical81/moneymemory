//
//  CoreDataManager.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreDataManager : NSObject  {
    NSManagedObjectContext *context;
    NSFetchedResultsController *fetchedResultsController;    
}

-(void) run: (NSManagedObjectContext*) moc;

@end
