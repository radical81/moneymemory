//
//  TransactionDomainObject.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryDomainObject.h"

@interface TransactionDomainObject : NSObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) CategoryDomainObject* is_a;

-(void) resetValues;

@end
