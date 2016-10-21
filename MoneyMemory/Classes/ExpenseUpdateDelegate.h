//
//  ExpenseUpdate.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 21/10/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol ExpenseUpdateDelegate <NSObject>

-(void) expenseDidChange;

@end
