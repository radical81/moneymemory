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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM YYYY"];
    NSString* currentMonth = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    _headerLabel.text = currentMonth;
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
        UIColor* color;
        if(counter % 2 == 0) {
            color = PNRed;
        }
        else if(counter % 3 == 0) {
            color = PNBlue;
        }
        else {
            color = PNGreen;
        }
        
        double expenseValue = [[dict objectForKey:@"percent" ] doubleValue];
        NSString* categoryName = [dict objectForKey:@"name"];
        [items addObject:[PNPieChartDataItem dataItemWithValue:expenseValue color:color description: categoryName]];
        
    }
//    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed],
//                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"WWDC"],
//                       [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"GOOL I/O"],
//                       ];
    
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:[items copy]];
    pieChart.descriptionTextColor = [UIColor grayColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    pieChart.hideValues = YES;
    [pieChart strokeChart];
    [self.view addSubview:pieChart];
    [logicManager release];
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
    [super dealloc];
}
@end
