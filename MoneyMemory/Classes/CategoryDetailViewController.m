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
#import "DesignHelper.h"

@interface CategoryDetailViewController ()

@end

@implementation CategoryDetailViewController 

@synthesize category = _category;
@synthesize expensesTable = _expensesTable;
@synthesize categoryLimit = _categoryLimit;
@synthesize totalExpenses = _totalExpenses;
@synthesize background = _background;
@synthesize addExpenseTop = _addExpenseTop;

CGFloat const GRAPH_LEFT_MARGIN = 50;
CGFloat const GRAPH_TOP_POSITION = 170;
int const GRAPH_LINE_WIDTH = 40;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _category.name;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCategoryDetails)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _expensesTable = [[ExpensesTableViewController alloc] initWithCategory:_category];
    _expensesTable.categoryDelegate = self;
    DesignHelper* designHelper = [[DesignHelper alloc] init];
    _background.image = [designHelper addBackgroundByScreenSize:@"background"];
    [designHelper release];
    [self calculateAndDisplayTotalExpenses];
}
- (void)viewWillAppear:(BOOL)animated {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:2];
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    NSString* categoryMax = [NSString stringWithFormat:@"Limit: $ %@", [formatter stringFromNumber:_category.limit]];
    _categoryLimit.text = categoryMax;
}

-(void) drawCircleChart:(NSNumber*) totalExpense {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat graphWidth = screenWidth - (GRAPH_LEFT_MARGIN*2);
    
    if([[self.view viewWithTag:200] isKindOfClass:[PNCircleChart class]]) {
        [[self.view viewWithTag:200] removeFromSuperview];
        _addExpenseTop.constant -= graphWidth;
    }
    _addExpenseTop.constant += graphWidth;
    PNCircleChart * circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(GRAPH_LEFT_MARGIN, GRAPH_TOP_POSITION, graphWidth, graphWidth) total:_category.limit current:totalExpense clockwise:NO shadow: YES shadowColor: [UIColor colorWithRed:85/255.f green:107/255.f blue:47/255.f alpha:0.5]];
    circleChart.backgroundColor = [UIColor clearColor];
    [circleChart setStrokeColor:[UIColor colorWithRed:205/255.f green:60/255.f blue:60/255.f alpha:0.5]];
    [circleChart setLineWidth:[NSNumber numberWithInt:GRAPH_LINE_WIDTH]];
    circleChart.countingLabel.font = [UIFont boldSystemFontOfSize:32.0f];
    [circleChart strokeChart];
    circleChart.tag = 200;
    [self.view addSubview:circleChart];
}

-(void) calculateAndDisplayTotalExpenses {
    TransactionsLogicManager* transactionLogic = [[TransactionsLogicManager alloc]init];
    NSNumber* totalExpensesAmount = [transactionLogic calculateTotalForCategory:[_category.id intValue] _givenDate:[NSDate date]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:2];
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    NSString* totalExpensesNow = [NSString stringWithFormat:@"Total: $ %@", [formatter stringFromNumber:totalExpensesAmount]];
    [_totalExpenses setText: totalExpensesNow];
    [transactionLogic release];
    [self drawCircleChart:totalExpensesAmount];
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
    [_background release];
    [_addExpenseTop release];
    [super dealloc];
}

- (IBAction)didPressNewExpense:(id)sender {
    SpendMoneyViewController* spendMoneyViewController = [[[SpendMoneyViewController alloc]initWithNibName:@"SpendMoneyViewController" bundle:nil]autorelease];
    spendMoneyViewController.category = _category;
    spendMoneyViewController.categoryDelegate = self;
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
    
}

- (IBAction)didPressViewExpenses:(id)sender {
    NSLog(@"View Expenses in Category...");
    [self.navigationController pushViewController:_expensesTable animated:YES];
}

@end
