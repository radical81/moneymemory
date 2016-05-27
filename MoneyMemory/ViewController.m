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
@synthesize backgroundImage = _backgroundImage;

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
    [self addBackgroundByScreenSize];
    [super viewDidLoad];
}

-(void)addBackgroundByScreenSize {
    if([UIScreen mainScreen].bounds.size.height == 480) {
        NSLog(@"iPhone 4");
        _backgroundImage.image = [UIImage imageNamed:@"background640x960.png"];
        return;
    }
    if([UIScreen mainScreen].bounds.size.height == 568) {
        NSLog(@"iPhone 5");
        _backgroundImage.image = [UIImage imageNamed:@"background640x1136.png"];
        return;
    }
    if([UIScreen mainScreen].bounds.size.height == 667) {
        NSLog(@"iPhone 6");
        _backgroundImage.image = [UIImage imageNamed:@"background750x1334.png"];
        return;
    }
    if([UIScreen mainScreen].bounds.size.height == 736) {
        NSLog(@"iPhone 6 Plus");
        _backgroundImage.image = [UIImage imageNamed:@"background1242x2208.png"];
        return;
    }
    NSLog(@"iPhone");
    _backgroundImage.image = [UIImage imageNamed:@"background320x480"];
}

-(IBAction)loadIncomeView:(id)sender {
    NSLog(@"loadIncomeView");
    [self.navigationController pushViewController:_incomeView animated:YES];
}

-(IBAction)loadExpenses:(id)sender {
    TransactionsLogicManager* logicManager = [[[TransactionsLogicManager alloc]init]autorelease];
    NSArray* expenses = [logicManager fetchAllTransactions:1];
    if([expenses count] == 0) {
        [self showAlertNoTransactions];
        return;
    }
    [self.navigationController pushViewController:_expensesTableView animated:YES];
}

-(void) showAlertMissingIncome {
    
    NSString* errorMessage = @"Please provide your income first.";
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Income Needed"
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

-(void) showAlertNoTransactions {
    NSString* errorMessage = @"You have no expenses yet.";
    
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"No Expenses"
                                  message: errorMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
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
    TransactionsLogicManager* logicManager = [[[TransactionsLogicManager alloc]init]autorelease];
    NSArray* expenses = [logicManager fetchAllTransactions:1];
    if([expenses count] == 0) {
        [self showAlertNoTransactions];
        return;
    }
    
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
    [_backgroundImage release];
    [super dealloc];
}
@end
