//
//  HistoryMonthYearTableViewController.m
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 2/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "HistoryMonthYearTableViewController.h"
#import "TransactionsLogicManager.h"
#import "DateFormatHelper.h"

@interface HistoryMonthYearTableViewController ()

@property(nonatomic, retain) NSDictionary* yearMonths;
@property(nonatomic, retain) NSArray* yearsDesc;
@property(nonatomic, retain) DateFormatHelper* dateHelper;

@end

@implementation HistoryMonthYearTableViewController {
    TransactionsLogicManager* logicManager;
}

@synthesize yearMonths = _yearMonths;
@synthesize yearsDesc = _yearsDesc;
@synthesize historyTable = _historyTable;
@synthesize dateHelper = _dateHelper;

- (id) initWithAll {
    NSLog(@"initWithAll...");
    self = [super initWithNibName:@"HistoryMonthYearTableViewController" bundle:nil];
    
    if(self) {
        logicManager = [[TransactionsLogicManager alloc]init];
        [_historyTable retain];
        self.tableView.delegate = self;
    }
    return self;
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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear Filter" style:UIBarButtonItemStyleDone target:self action:@selector(clearDateFilter)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
}

-(void) viewWillAppear:(BOOL)animated {
    NSArray* timeStamps = [logicManager fetchTimeStamps];
    NSLog(@"Time stamps History: %@", timeStamps);
    _dateHelper = [[DateFormatHelper alloc]init];
    _yearMonths = [[self generateYearMonths:timeStamps]retain];
    NSLog(@"Year months: %@", _yearMonths);
    _yearsDesc = [[[[[_yearMonths allKeys] sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects]retain];
    NSLog(@"Years sorted descending: %@", _yearsDesc);
    [self.tableView reloadData];
}

-(void) clearDateFilter {
    [_historyTable unsetMonthYear];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary*) generateYearMonths:(NSArray*)timeStamps {
    NSLog(@"generateYearMonths...");
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

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_yearsDesc objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_yearsDesc count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* yearKey = [_yearsDesc objectAtIndex:section];
    NSArray* monthsOfThisYear = [_yearMonths objectForKey:yearKey];
    return [monthsOfThisYear count];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString* yearKey = [_yearsDesc objectAtIndex:indexPath.section];
    NSArray* monthsOfThisYear = [_yearMonths objectForKey:yearKey];
    
    [_historyTable setMonthYear:[monthsOfThisYear objectAtIndex:indexPath.row]];
    
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
