//
//  CategoryDetailViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 19/2/15.
//  Copyright (c) 2015 Rex Jason Alobba. All rights reserved.
//

#import "CategoryDetailViewController.h"
#import "AddCategoryViewController.h"
#import "SpendMoneyViewController.h"
#import "TransactionsLogicManager.h"

@interface CategoryDetailViewController ()

@end

@implementation CategoryDetailViewController 

@synthesize category = _category;
@synthesize expensesTable = _expensesTable;
@synthesize categoryLimit = _categoryLimit;
@synthesize totalExpenses = _totalExpenses;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _category.name;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCategoryDetails)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _expensesTable = [[ExpensesTableViewController alloc] initWithCategory:_category];
    
    [self calculateAndDisplayTotalExpenses];
}
- (void)viewWillAppear:(BOOL)animated {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:2];
    NSString* categoryMax = [NSString stringWithFormat:@"$ %@", [formatter stringFromNumber:_category.limit]];
    _categoryLimit.text = categoryMax;
    [self calculateAndDisplayTotalExpenses];
}

-(void) calculateAndDisplayTotalExpenses {
    TransactionsLogicManager* transactionLogic = [[TransactionsLogicManager alloc]init];
    NSNumber* totalExpensesAmount = [transactionLogic calculateTotalForCategory:[_category.id intValue]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:2];
    NSString* totalExpensesNow = [NSString stringWithFormat:@"$ %@", [formatter stringFromNumber:totalExpensesAmount]];
    [_totalExpenses setText: totalExpensesNow];
    [transactionLogic release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) editCategoryDetails {
    NSLog(@"Edit category...");
    AddCategoryViewController* addCategoryViewController = [[[AddCategoryViewController alloc]initWithCategory: _category]autorelease];
    [self.navigationController pushViewController:addCategoryViewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_category release];
    [_expensesTable release];
    [_totalExpenses release];
    [_categoryLimit release];
    [super dealloc];
}

- (IBAction)didPressNewExpense:(id)sender {
    SpendMoneyViewController* spendMoneyViewController = [[[SpendMoneyViewController alloc]initWithNibName:@"SpendMoneyViewController" bundle:nil]autorelease];
    spendMoneyViewController.category = _category;
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
    
}

- (IBAction)didPressViewExpenses:(id)sender {
    [self.navigationController pushViewController:_expensesTable animated:YES];
}

@end
