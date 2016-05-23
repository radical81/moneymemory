//
//  ViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 16/9/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "ViewController.h"
#import "RunTestCoreData.h"
#import "SpendMoneyViewController.h"
#import "TransactionCategoriesViewController.h"
#import "ExpensesTableViewController.h"

@interface ViewController ()

@property (nonatomic, retain) ExpensesTableViewController* expensesTableView;

@end

@implementation ViewController

@synthesize incomeView = _incomeView;
@synthesize categoriesTableView = _categoriesTableView;
@synthesize expensesTableView = _expensesTableView;

- (void)viewDidLoad
{

	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"This is money memory");
    RunTestCoreData* rc = [[RunTestCoreData alloc]init];
    //[rc runTestData];
    [rc viewTransactions];
    [rc release];
    _categoriesTableView = [[TransactionCategoriesViewController alloc]initWithNibName:@"TransactionCategoriesViewController" bundle:nil];    
    _incomeView = [[IncomeViewController alloc]initWithNibName:@"IncomeViewController" bundle:nil];
    _expensesTableView = [[ExpensesTableViewController alloc] initWithAll];
    [super viewDidLoad];
    self.navigationItem.title = @"Money Memory";
}

-(IBAction)loadIncomeView:(id)sender {
    NSLog(@"loadIncomeView");
    [self.navigationController pushViewController:_incomeView animated:YES];
}

-(IBAction)loadExpenses:(id)sender {
    [self.navigationController pushViewController:_expensesTableView animated:YES];
}


-(IBAction)loadCategoriesTableView:(id)sender {
    NSLog(@"loadCategoriesTableView");
    [self.navigationController pushViewController:_categoriesTableView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_incomeView release];
    [_transactionCategoriesButton release];
    [_categoriesTableView release];
    [_expensesTableView release];
    [super dealloc];
}
@end
