//
//  GraphViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 24/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "GraphViewController.h"
#import "PNChart.h"
#import "TransactionsLogicManager.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

@synthesize headerLabel = _headerLabel;
@synthesize monthTotal = _monthTotal;
@synthesize categoryPercent = _categoryPercent;

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
    //For Pie Chart
    NSArray* expensesData = [logicManager retrieveTotalsForEachCategory: [NSDate date]];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    int counter = 0;
    for(NSDictionary* dict in expensesData) {
        counter++;
        double expenseValue = [[dict objectForKey:@"percent" ] doubleValue];
        NSString* categoryName = [dict objectForKey:@"name"];
        if([categoryName isEqualToString:@"SAVINGS"]) {
            _categoryPercent.text = [NSString stringWithFormat:@"Savings: %.2f %%", expenseValue];
        }
        UIColor* color = [self generatePieColor:counter];
        NSLog(@"Color %@", color);
        [items addObject:[PNPieChartDataItem dataItemWithValue:expenseValue color:color description: categoryName]];
        color = nil;
    }
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:[items copy]];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Gill Sans" size:12.0];
    pieChart.hideValues = YES;
    [pieChart strokeChart];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_monthTotal release];
    [_headerLabel release];
    [_categoryPercent release];
    [super dealloc];
}
@end
