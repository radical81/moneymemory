//
//  ExpenseDateFilterDelegate.h
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 2/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExpenseDateFilterDelegate <NSObject>

-(void) setMonthYear:(NSString*) monthYear;
-(void) unsetMonthYear;

@end
