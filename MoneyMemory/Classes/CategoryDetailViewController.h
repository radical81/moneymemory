//
//  CategoryDetailViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 19/2/15.
//  Copyright (c) 2015 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDomainObject.h"

@interface CategoryDetailViewController : UIViewController

@property (nonatomic, retain) CategoryDomainObject* category;
@property (retain, nonatomic) IBOutlet UILabel *transactionType;
@property (retain, nonatomic) IBOutlet UILabel *totalExpenses;
@property (retain, nonatomic) IBOutlet UILabel *categoryLimit;
- (IBAction)didPressNewExpense:(id)sender;

@end
