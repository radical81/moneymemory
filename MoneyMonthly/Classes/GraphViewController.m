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

@property(nonatomic, retain) NSDate* currentDate;
@end

@implementation GraphViewController

@synthesize headerLabel = _headerLabel;
@synthesize monthTotal = _monthTotal;
@synthesize categoryPercent = _categoryPercent;
@synthesize clickedLabel = _clickedLabel;
@synthesize tipLabel = _tipLabel;
@synthesize monthYearTable = _monthYearTable;
@synthesize currentDate = _currentDate;


- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Select Month" style:UIBarButtonItemStylePlain target:self action:@selector(didTapChange)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _monthYearTable = [[StatsMonthYearTableViewController alloc]initWithAll];
    _monthYearTable.graphDisplay = self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM YYYY"];
    if(_currentDate == nil) {
        _currentDate = [[NSDate date]retain];
    }
    NSString* currentMonth = [dateFormatter stringFromDate:_currentDate];
    [dateFormatter release];
    _headerLabel.text = currentMonth;
    if([[self.view viewWithTag:100] isKindOfClass:[PNPieChart class]]) {
        [[self.view viewWithTag:100] removeFromSuperview];
    }
    [self generatePieGraph];
}

-(void) didTapChange {
    [self.navigationController pushViewController:_monthYearTable animated:YES];
}

-(void) generatePieGraph {
    TransactionsLogicManager* logicManager = [[TransactionsLogicManager alloc]init];
    NSNumber* totalThisMonth = [logicManager calculateTotalForMonth:_currentDate];
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
    _tipLabel.text = @"Tap on the pie slices to show details.";
    
    //For Pie Chart
    NSArray* expensesData = [logicManager retrieveTotalsForEachCategory:_currentDate];
    NSMutableArray *items = [[NSMutableArray alloc]init];
    int counter = 0;
    for(NSDictionary* dict in expensesData) {
        counter++;
        double expenseValue = [[dict objectForKey:@"percent"] doubleValue];
        NSString* categoryName = [dict objectForKey:@"name"];
        UIColor* color = [self generatePieColor:counter];
        if([categoryName isEqualToString:@"SAVINGS"]) {
            color = [UIColor colorWithRed:85/255.f green:107/255.f blue:47/255.f alpha:0.5f];
        }
        NSLog(@"Name: %@",categoryName);
        NSLog(@"Color %@", color);
        [items addObject:[PNPieChartDataItem dataItemWithValue:expenseValue color:color description: categoryName]];
        color = nil;
    }
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(40.0, 155.0, 240.0, 240.0) items:[items copy]];
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    pieChart.showOnlyValues = YES;
    pieChart.delegate = self;
    pieChart.labelPercentageCutoff = 0.05;
    [pieChart strokeChart];
    pieChart.tag = 100;
    [self.view addSubview:pieChart];
    [logicManager release];
}

- (UIColor*) generatePieColor:(int)i {
    NSLog(@"generatePieColor for %d", i);

    if(i % 10 == 0) {
        return PNDeepGrey;
    }
    if(i % 9 == 0) {
        return [UIColor colorWithRed:111/255.f green:165/255.f blue:16/255.f alpha:1.0f];
    }
    if(i % 8 == 0) {
        return PNDarkBlue;
    }
    if(i % 7 == 0) {
        return PNDarkYellow;
    }
    if(i % 6 == 0) {
        return PNBlue;
    }
    if(i % 5 == 0) {
        return PNPinkDark;
    }
    if(i % 4 == 0) {
        return PNMauve;
    }
    if(i % 3 == 0) {
        return PNYellow;
    }
    if(i % 2 == 0) {
        return PNLightBlue;
    }
    return PNStarYellow;
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
    [_monthYearTable release];
    [_currentDate release];
    [_tipLabel release];
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

-(void) setMonthYear: (NSString*) monthYear {
    NSLog(@"setMonthYear: %@", monthYear);
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    NSLog(@"Use %@",[NSString stringWithFormat:@"1 %@",monthYear]);
    NSDate* newDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"1 %@",monthYear]];
    NSLog(@"The new date is %@", [dateFormatter stringFromDate:newDate]);
    _currentDate = newDate;
}

@end
