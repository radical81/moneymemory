//
//  CategoryDomainObject.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 18/10/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "CategoryDomainObject.h"

@implementation CategoryDomainObject

@synthesize id;
@synthesize limit;
@synthesize name;
@synthesize visible;

-(void) resetValues {
    self.id = nil;
    self.limit = nil;
    self.name = nil;
    self.visible = YES;
}

@end
