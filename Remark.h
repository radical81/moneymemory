//
//  Remark.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 6/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Remark : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSSet *is_about;
@end

@interface Remark (CoreDataGeneratedAccessors)

- (void)addIs_aboutObject:(NSManagedObject *)value;
- (void)removeIs_aboutObject:(NSManagedObject *)value;
- (void)addIs_about:(NSSet *)values;
- (void)removeIs_about:(NSSet *)values;

@end
