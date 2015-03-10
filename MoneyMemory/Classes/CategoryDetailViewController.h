//
//  CategoryDetailViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 19/2/15.
//  Copyright (c) 2015 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailViewController : UIViewController

@property  (nonatomic, retain) NSNumber* transactionCategory;
@property (nonatomic, retain) NSString* transactionCategoryText;
@property (retain, nonatomic) IBOutlet UILabel *transactionType;
@property (retain, nonatomic) IBOutlet UILabel *totalExpenses;
- (IBAction)didPressNewExpense:(id)sender;

@end
