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
#import "TransactionsLogicManager.h"

@interface ViewController ()

@property (nonatomic, retain) ExpensesTableViewController* expensesTableView;

@end

@implementation ViewController

@synthesize incomeView = _incomeView;
@synthesize categoriesTableView = _categoriesTableView;
@synthesize expensesTableView = _expensesTableView;
@synthesize graphView = _graphView;

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
    _graphView = [[GraphViewController alloc]init];
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

-(void) showAlertMissingIncome {
    
    NSString* errorMessage = @"Please provide your income first.";
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Income needed"
                                  message: errorMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self.navigationController pushViewController:_incomeView animated:YES];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


-(IBAction)loadCategoriesTableView:(id)sender {
    NSLog(@"loadCategoriesTableView");
    TransactionsLogicManager* logicManager = [[[TransactionsLogicManager alloc]init]autorelease];
    double amount = [logicManager retrieveIncomeMonthly];
    if(amount == 0) {
        [self showAlertMissingIncome];
        return;
    }
    
    [self.navigationController pushViewController:_categoriesTableView animated:YES];
}

- (IBAction)loadGraphView:(id)sender {
    [self.navigationController pushViewController:_graphView animated:YES];
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
    [_graphView release];
    [super dealloc];
}
@end
