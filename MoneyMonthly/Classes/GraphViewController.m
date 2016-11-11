//
//  GraphViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 24/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "GraphViewController.h"
#import "TransactionsLogicManager.h"
#import "CurrencyHelper.h"
#import "DateFormatHelper.h"

@interface GraphViewController ()
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *sliceTap;
@property(nonatomic, retain) NSDate* currentDate;
@property(nonatomic, retain) DateFormatHelper* dateHelper;
@end

@implementation GraphViewController

@synthesize headerLabel = _headerLabel;
@synthesize monthTotal = _monthTotal;
@synthesize categoryPercent = _categoryPercent;
@synthesize clickedLabel = _clickedLabel;
@synthesize tipLabel = _tipLabel;
@synthesize monthYearTable = _monthYearTable;
@synthesize currentDate = _currentDate;
@synthesize sliceTap = _sliceTap;
@synthesize dateHelper = _dateHelper;

CGFloat const PIE_GRAPH_LEFT_MARGIN = 40;
CGFloat const PIE_GRAPH_TOP_POSITION = 220;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Select Month" style:UIBarButtonItemStyleDone target:self action:@selector(didTapChange)];
    self.navigationItem.rightBarButtonItem = rightButton;
    _monthYearTable = [[StatsMonthYearTableViewController alloc]initWithAll];
    _monthYearTable.graphDisplay = self;
    _dateHelper = [[DateFormatHelper alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    if(_currentDate == nil) {
        _currentDate = [[NSDate date]retain];
    }
    NSString* currentMonth = [_dateHelper stringMonthYear:_currentDate];
    _headerLabel.text = currentMonth;
    [self generatePieGraph];
}

-(void) didTapChange {
    [self.navigationController pushViewController:_monthYearTable animated:YES];
}

-(void) generatePieGraph {
    NSLog(@"generatePieGraph...");
    TransactionsLogicManager* logicManager = [[TransactionsLogicManager alloc]init];
    NSNumber* totalThisMonth = [logicManager calculateTotalForMonth:_currentDate];
    CurrencyHelper* helper = [[CurrencyHelper alloc]init];
    _monthTotal.text = [NSString stringWithFormat:@"Total Expenses: $ %@", [helper numberWithComma:totalThisMonth]];
    double monthlyIncome = [logicManager retrieveIncomeMonthly: [_currentDate timeIntervalSince1970]];
    NSLog(@"Monthly income %f", monthlyIncome);
    double remaining = monthlyIncome - [totalThisMonth doubleValue];
    _categoryPercent.text = [NSString stringWithFormat:@"Savings: $ %@", [helper numberWithComma:[NSNumber numberWithDouble:remaining]]];
    [helper release];
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
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat graphWidth = screenWidth - (PIE_GRAPH_LEFT_MARGIN*2);
    if([[self.view viewWithTag:100] isKindOfClass:[PNPieChart class]]) {
        [[self.view viewWithTag:100] removeFromSuperview];
        _sliceTap.constant -= graphWidth;
    }    
    _sliceTap.constant += graphWidth;
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(PIE_GRAPH_LEFT_MARGIN, PIE_GRAPH_TOP_POSITION, graphWidth, graphWidth) items:[items copy]];
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
    [_sliceTap release];
    [_dateHelper release];
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
    

    NSDate* monthBegin = [_dateHelper dateFromDayMonthYear:[NSString stringWithFormat:@"1 %@",monthYear]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* componentOffset = [[NSDateComponents alloc]init];
    [componentOffset setMonth:1];
    [componentOffset setDay: -1];
    
    NSDate* monthEnd = [calendar dateByAddingComponents:componentOffset toDate:monthBegin options:NSCalendarMatchStrictly];
    
    _currentDate = [monthEnd retain];
    [componentOffset release];
}

@end
