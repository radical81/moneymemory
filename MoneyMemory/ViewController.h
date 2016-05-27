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

-(IBAction)loadIncomeView:(id)sender;
-(IBAction)loadExpenses:(id)sender;
-(IBAction)loadCategoriesTableView:(id)sender;
-(IBAction)loadGraphView:(id)sender;

@end
