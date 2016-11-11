//
//  StatsMonthYearTableViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 26/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "StatsMonthYearTableViewController.h"
#import "TransactionsLogicManager.h"
#import "DateFormatHelper.h"

@interface StatsMonthYearTableViewController ()

@property(nonatomic, retain) NSDictionary* yearMonths;
@property(nonatomic, retain) NSArray* yearsDesc;
@property(nonatomic, retain) DateFormatHelper* dateHelper;

@end

@implementation StatsMonthYearTableViewController {
    TransactionsLogicManager* logicManager;
}

@synthesize yearMonths = _yearMonths;
@synthesize yearsDesc = _yearsDesc;
@synthesize graphDisplay = _graphDisplay;
@synthesize dateHelper = _dateHelper;

- (id) initWithAll {
    NSLog(@"initWithAll...");
    self = [super initWithNibName:@"StatsMonthYearTableViewController" bundle:nil];
    
    if(self) {
        logicManager = [[TransactionsLogicManager alloc]init];
        [_graphDisplay retain];
        self.tableView.delegate = self;
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    NSArray* timeStamps = [logicManager fetchTimeStamps];
    NSLog(@"Time stamps Stats: %@", timeStamps);
    _dateHelper = [[DateFormatHelper alloc]init];
    _yearMonths = [[self generateYearMonths:timeStamps]retain];
    NSLog(@"Year months: %@", _yearMonths);
    _yearsDesc = [[[[[_yearMonths allKeys] sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects]retain];
    NSLog(@"Years sorted descending: %@", _yearsDesc);
    [self.tableView reloadData];
}

-(void) dealloc {
    [_dateHelper release];
    if(logicManager) {
        [logicManager release];
        logicManager = nil;
    }
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary*) generateYearMonths:(NSArray*)timeStamps {
    NSMutableDictionary* returnYearMonths = [[[NSMutableDictionary alloc]init]autorelease];
    for(NSNumber* t in timeStamps) {
        NSDate* transactionDate = [NSDate dateWithTimeIntervalSince1970:[t doubleValue]];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitYear fromDate:transactionDate];
        NSString* year = [NSString stringWithFormat:@"%ld", (long)[components year]];
        NSLog(@"year: %@", year);
        NSString* month = [_dateHelper stringMonthYear:transactionDate];
        NSMutableArray* months = [returnYearMonths objectForKey:year];
        if(months == nil) {
            months = [NSMutableArray array];
            [returnYearMonths setObject:months forKey:year];
        }
        if([months containsObject:month] == NO) {
            [months addObject:month];
        }
    }
    return [returnYearMonths copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_yearsDesc count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* yearKey = [_yearsDesc objectAtIndex:section];
    NSArray* monthsOfThisYear = [_yearMonths objectForKey:yearKey];
    return [monthsOfThisYear count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_yearsDesc objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSString* yearKey = [_yearsDesc objectAtIndex:indexPath.section];
    NSArray* monthsOfThisYear = [_yearMonths objectForKey:yearKey];
    cell.textLabel.text = [monthsOfThisYear objectAtIndex:indexPath.row];
    
    return cell;
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    NSString* yearKey = [_yearsDesc objectAtIndex:indexPath.section];
    NSArray* monthsOfThisYear = [_yearMonths objectForKey:yearKey];
    
    [_graphDisplay setMonthYear:[monthsOfThisYear objectAtIndex:indexPath.row]];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
