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
#import "DesignHelper.h"

@interface ViewController ()

@property (nonatomic, retain) ExpensesTableViewController* expensesTableView;

@end

@implementation ViewController

@synthesize incomeView = _incomeView;
@synthesize categoriesTableView = _categoriesTableView;
@synthesize expensesTableView = _expensesTableView;
@synthesize graphView = _graphView;
@synthesize backgroundImage = _backgroundImage;
@synthesize incomeTop = _incomeTop;
@synthesize incomeLeading = _incomeLeading;
@synthesize incomeWidth = _incomeWidth;
@synthesize incomeHeight = _incomeHeight;
@synthesize expensesTop = _expensesTop;
@synthesize expensesTrailing = _expensesTrailing;
@synthesize expensesWidth = _expensesWidth;
@synthesize expensesHeight = _expensesHeight;
@synthesize spendTop = _spendTop;
@synthesize spendLeading = _spendLeading;
@synthesize spendWidth = _spendWidth;
@synthesize spendHeight = _spendHeight;
@synthesize statsTop = _statsTop;
@synthesize statsTrailing = _statsTrailing;
@synthesize statsWidth = _statsWidth;
@synthesize statsHeight = _statsHeight;

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {

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
    [self resetButtonSizes];
    DesignHelper* designHelper = [[DesignHelper alloc]init];
    _backgroundImage.image = [designHelper addBackgroundByScreenSize:@"backgroundLogo"];
    [designHelper release];
    [super viewDidLoad];
}

-(void) resetButtonSizes {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height + 20;
    _incomeTop.constant = navBarHeight + screenHeight * 0.15;
    _incomeLeading.constant = screenWidth * 0.07;
    _incomeWidth.constant = screenWidth * 0.4;
    _incomeHeight.constant = screenWidth * 0.4;
    _expensesTop.constant = navBarHeight + screenHeight * 0.15;
    _expensesTrailing.constant = screenWidth * 0.07;
    _expensesWidth.constant = screenWidth * 0.4;
    _expensesHeight.constant = screenWidth * 0.4;
    _spendTop.constant = screenHeight * 0.07;
    _spendLeading.constant = screenWidth * 0.07;
    _spendWidth.constant = screenWidth * 0.4;
    _spendHeight.constant = screenWidth * 0.4;
    _statsTop.constant = screenHeight * 0.07;
    _statsTrailing.constant = screenWidth * 0.07;
    _statsWidth.constant = screenWidth * 0.4;
    _statsHeight.constant = screenWidth * 0.4;
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
    [_incomeTop release];
    [_incomeLeading release];
    [_incomeWidth release];
    [_incomeHeight release];
    [_expensesTop release];
    [_expensesTrailing release];
    [_expensesWidth release];
    [_expensesHeight release];
    [_spendTop release];
    [_spendLeading release];
    [_spendWidth release];
    [_spendHeight release];
    [_statsTop release];
    [_statsTrailing release];
    [_statsWidth release];
    [_statsHeight release];
    [super dealloc];
}
@end
