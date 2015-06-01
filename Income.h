//
//  Income.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 1/6/15.
//  Copyright (c) 2015 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Income : NSManagedObject

@property (nonatomic, retain) NSNumber * monthly;
@property (nonatomic, retain) NSNumber * id;

@end
