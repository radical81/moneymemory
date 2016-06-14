//
//  ViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 16/9/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionCategoriesViewController.h"
#import "IncomeViewController.h"
#import "GraphViewController.h"

@interface ViewController : UIViewController 

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (retain, nonatomic) IBOutlet UIButton *transactionCategoriesButton;
@property (nonatomic, retain) TransactionCategoriesViewController * categoriesTableView;
@property (nonatomic, retain) IncomeViewController *incomeView;
@property (nonatomic, retain) GraphViewController *graphView;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *incomeTop;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *incomeLeading;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *incomeWidth;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *incomeHeight;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *expensesTop;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *expensesTrailing;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *expensesWidth;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *expensesHeight;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *spendLeading;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *spendTop;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *spendWidth;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *spendHeight;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *statsTop;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *statsTrailing;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *statsWidth;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *statsHeight;



-(IBAction)loadIncomeView:(id)sender;
-(IBAction)loadExpenses:(id)sender;
-(IBAction)loadCategoriesTableView:(id)sender;
-(IBAction)loadGraphView:(id)sender;

@end
