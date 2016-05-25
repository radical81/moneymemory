//
//  GraphViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 24/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "GraphViewController.h"
#import "TransactionsLogicManager.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

@synthesize headerLabel = _headerLabel;
@synthesize monthTotal = _monthTotal;
@synthesize categoryPercent = _categoryPercent;
@synthesize clickedLabel = _clickedLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM YYYY"];
    NSString* currentMonth = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    _headerLabel.text = currentMonth;
}

- (void)viewWillAppear:(BOOL)animated {
    [self generatePieGraph];
}


-(void) generatePieGraph {
    TransactionsLogicManager* logicManager = [[TransactionsLogicManager alloc]init];
    NSNumber* totalThisMonth = [logicManager calculateTotalForMonth:[NSDate date]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:2];
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    _monthTotal.text = [NSString stringWithFormat:@"Total Expenses: $ %@", [formatter stringFromNumber:totalThisMonth]];

    double monthlyIncome = [logicManager retrieveIncomeMonthly];
    double remaining = monthlyIncome - [totalThisMonth doubleValue];
    _categoryPercent.text = [NSString stringWithFormat:@"Savings: $ %@", [formatter stringFromNumber:[NSNumber numberWithDouble:remaining]]];
    _clickedLabel.text = @"";
    
    //For Pie Chart
    NSArray* expensesData = [logicManager retrieveTotalsForEachCategory: [NSDate date]];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    int counter = 0;
    for(NSDictionary* dict in expensesData) {
        counter++;
        double expenseValue = [[dict objectForKey:@"percent"] doubleValue];
        NSString* categoryName = [dict objectForKey:@"name"];
        UIColor* color = [self generatePieColor:counter];
        NSLog(@"Color %@", color);
        [items addObject:[PNPieChartDataItem dataItemWithValue:expenseValue color:color description: categoryName]];
        color = nil;
    }
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:[items copy]];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Gill Sans" size:12.0];
    pieChart.hideValues = YES;
    pieChart.delegate = self;
    [pieChart strokeChart];
    pieChart.tag = 100;
    [self.view addSubview:pieChart];
    [logicManager release];
}

- (UIColor*) generatePieColor:(int)i {
    NSLog(@"generatePieColor for %d", i);

    if(i % 10 == 0) {
        return PNBlue;
    }
    if(i % 9 == 0) {
        return PNYellow;
    }
    if(i % 8 == 0) {
        return PNMauve;
    }
    if(i % 7 == 0) {
        return PNDarkBlue;
    }
    if(i % 6 == 0) {
        return PNPinkGrey;
    }
    if(i % 5 == 0) {
        return PNBrown;
    }
    if(i % 4 == 0) {
        return PNLightYellow;
    }
    if(i % 3 == 0) {
        return PNPinkDark;
    }
    if(i % 2 == 0) {
        return PNLightBlue;
    }
    return PNLightGreen;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_monthTotal release];
    [_headerLabel release];
    [_categoryPercent release];
    [_clickedLabel release];
    [super dealloc];
}

- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex {
    NSLog(@"pie index: %ld", (long)pieIndex);
    PNPieChart* pieChart = [self.view viewWithTag:100];
    PNPieChartDataItem* item = [pieChart.items objectAtIndex: pieIndex];
    NSLog(@"Clicked: %@", item.textDescription);
    NSLog(@"Value: %.2f", item.value);
    _clickedLabel.text = [NSString stringWithFormat:@"%@: %.2f%%", item.textDescription, item.value];
    [_clickedLabel setTextColor:item.color];
}

@end
