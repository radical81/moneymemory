//
//  CategoryDetailViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 19/2/15.
//  Copyright (c) 2015 Rex Jason Alobba. All rights reserved.
//

#import "CategoryDetailViewController.h"
#import "SpendMoneyViewController.h"
#import "TransactionsLogicManager.h"

@interface CategoryDetailViewController ()

@end

@implementation CategoryDetailViewController 

@synthesize category = _category;
@synthesize transactionType = _transactionType;
@synthesize totalExpenses = _totalExpenses;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_transactionType setText:_category.name];
    [self calculateAndDisplayTotalExpenses];
}
- (void)viewWillAppear:(BOOL)animated {
    [self calculateAndDisplayTotalExpenses];    
}

-(void) calculateAndDisplayTotalExpenses {
    TransactionsLogicManager* transactionLogic = [[TransactionsLogicManager alloc]init];
    NSNumber* totalExpensesAmount = [transactionLogic calculateTotalForCategory:[_category.id intValue]];
    [_totalExpenses setText: [totalExpensesAmount stringValue]];
    [transactionLogic release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_transactionType release];
    [_totalExpenses release];
    [super dealloc];
}
- (IBAction)didPressNewExpense:(id)sender {
    SpendMoneyViewController* spendMoneyViewController = [[[SpendMoneyViewController alloc]initWithNibName:@"SpendMoneyViewController" bundle:nil]autorelease];
    spendMoneyViewController.category = _category;
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
}

@end
