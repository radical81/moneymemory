//
//  CategoryDomainObject.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryDomainObject : NSObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * limit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) BOOL visible;

-(void) resetValues;

@end
