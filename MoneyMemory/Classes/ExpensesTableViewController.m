//
//  ExpensesTableViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 26/9/15.
//  Copyright © 2015 Rex Jason Alobba. All rights reserved.
//

#import "ExpensesTableViewController.h"
#import "SpendMoneyViewController.h"
#import "TransactionsLogicManager.h"

@interface ExpensesTableViewController ()

@property (nonatomic, retain) CategoryDomainObject* category;

@property(nonatomic, retain)  NSDictionary* expensesByDay;

@end

@implementation ExpensesTableViewController

@synthesize category = _category;
@synthesize expensesByDay = _expensesByDay;

TransactionsLogicManager* logicManager;

-(id) initWithCategory:(CategoryDomainObject*) category {
    self = [super initWithNibName:@"ExpensesTableViewController" bundle:nil];
    if(self) {
        _category = category;
        NSArray* expenses = [[logicManager fetchTransactionIsA:[_category.id intValue]] retain];
        _expensesByDay = [self groupExpensesByDate:expenses];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExpense)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [rightButton release];
    
    self.navigationItem.title = @"Expenses";    
}

- (NSString*)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    
    return [dateFormatter stringFromDate:beginningOfDay];
}

- (NSDictionary*) groupExpensesByDate:(NSArray*) expenses {
    NSMutableDictionary* dict = [[[NSMutableDictionary alloc]init]autorelease];
    for(TransactionDomainObject* t in expenses) {
        NSMutableArray *a = [dict objectForKey:[self dateAtBeginningOfDayForDate:[NSDate dateWithTimeIntervalSince1970:[t.timestamp doubleValue]]]];
        if (a == nil) {
            a = [NSMutableArray array];
            // Use the reduced date as dictionary key to later retrieve the expense list this day
            [dict setObject:a forKey:[self dateAtBeginningOfDayForDate:[NSDate dateWithTimeIntervalSince1970:[t.timestamp doubleValue]]]];
        }
        
        // Add the event to the list for this day
        [a addObject:t];
    }
    NSLog(@"Expenses by date: %@", dict);
    return dict;
}

- (void)addExpense {
    SpendMoneyViewController* spendMoneyViewController = [[[SpendMoneyViewController alloc]initWithNibName:@"SpendMoneyViewController" bundle:nil]autorelease];
    spendMoneyViewController.category = _category;
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    [_expensesByDay release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
