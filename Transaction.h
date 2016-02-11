//
//  Transaction.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 17/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSString * imagepath;
@property (nonatomic, retain) Category *is_a;

@end
