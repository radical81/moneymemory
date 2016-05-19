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
@property BOOL byCategory;
@property int limit;
@property (strong, nonatomic) NSString *tableTitle;
@property(nonatomic, retain)  NSDictionary* expensesByDay;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;

@end

@implementation ExpensesTableViewController

@synthesize category;
@synthesize byCategory;
@synthesize limit;
@synthesize tableTitle;
@synthesize expensesByDay;
@synthesize sortedDays;
@synthesize sectionDateFormatter;

TransactionsLogicManager* logicManager;

-(id) initWithAll {
    self = [super initWithNibName:@"ExpensesTableViewController" bundle:nil];
    if(self) {
        self.tableView.delegate = self;
        self.byCategory = NO;
        self.tableTitle = @"Expenses";
        self.limit = 15;
        
        NSArray* expenses = [logicManager fetchAllTransactions: self.limit];
        NSLog(@"Expenses All: %@", expenses);
        self.expensesByDay = [[self groupExpensesByDate:expenses]retain];
        NSLog(@"%lu Expenses by Day: %@", (unsigned long)[self.expensesByDay count], self.expensesByDay);
        
        NSArray *unsortedDays = [self.expensesByDay allKeys];
        self.sortedDays = [[[unsortedDays sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
        NSLog(@"Sort by date: %@", self.sortedDays);
        self.sectionDateFormatter = [[NSDateFormatter alloc] init];
        self.sectionDateFormatter.timeStyle = NSDateFormatterNoStyle;
        self.sectionDateFormatter.dateStyle = NSDateFormatterMediumStyle;        

    }
    return self;
}

-(id) initWithCategory:(CategoryDomainObject*) _category {
    self = [super initWithNibName:@"ExpensesTableViewController" bundle:nil];
    if(self) {
        self.byCategory = YES;
        self.category = _category;
        self.tableTitle = [NSString stringWithFormat:@"Expenses: %@", self.category.name];
        self.limit = 15;
        NSArray* expenses = [logicManager fetchTransactionIsA:[self.category.id intValue] limit:self.limit];
        NSLog(@"Expenses: %@", expenses);
        self.expensesByDay = [[self groupExpensesByDate:expenses]retain];
        NSLog(@"%lu Expenses by Day: %@", (unsigned long)[self.expensesByDay count], self.expensesByDay);
        
        NSArray *unsortedDays = [self.expensesByDay allKeys];
        self.sortedDays = [[[unsortedDays sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
        NSLog(@"Sort by date: %@", self.sortedDays);
        self.sectionDateFormatter = [[NSDateFormatter alloc] init];
        self.sectionDateFormatter.timeStyle = NSDateFormatterNoStyle;
        self.sectionDateFormatter.dateStyle = NSDateFormatterMediumStyle;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    if(self.byCategory == YES) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExpense)];
        self.navigationItem.rightBarButtonItem = rightButton;    
        [rightButton release];
    }
    self.navigationItem.title = self.tableTitle;
}

- (NSDate*)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    
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

    return beginningOfDay;
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
    return dict;
}

- (void)addExpense {
    SpendMoneyViewController* spendMoneyViewController = [[[SpendMoneyViewController alloc]initWithNibName:@"SpendMoneyViewController" bundle:nil]autorelease];
    spendMoneyViewController.category = self.category;
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc {
    [super dealloc];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        NSLog(@"we are at the end");
        self.limit = self.limit + 15;
        [self launchReload];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.expensesByDay count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *expensesOnThisDay = [self.expensesByDay objectForKey:dateRepresentingThisDay];
    return [expensesOnThisDay count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *expensesThisDay = [self.expensesByDay objectForKey:dateRepresentingThisDay];
    TransactionDomainObject *transaction = [expensesThisDay objectAtIndex:indexPath.row];
    static NSString *reuseIdentifier = @"ExpenseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"$ %@", [transaction.amount stringValue]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", transaction.comment];
    
    UIImage *theImage = [UIImage imageNamed:@"budget_icon.png"];
    if(transaction.imagepath != NULL) {
        NSLog(@"Found image: %@", transaction.imagepath);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        NSString *pathToImage = [basePath stringByAppendingPathComponent:transaction.imagepath];
        NSLog(@"Path to Image: %@", pathToImage);
        if([UIImage imageWithContentsOfFile: pathToImage] != nil) {
            theImage = [UIImage imageWithContentsOfFile: pathToImage];
        }
    }
    cell.imageView.image = theImage;
    
    return cell;
}

-(void) launchReload {
    NSArray* expenses;
    
    if(self.byCategory == YES) {
        expenses = [logicManager fetchTransactionIsA:[self.category.id intValue] limit:self.limit];
    }
    else {
        expenses = [logicManager fetchAllTransactions: self.limit];
    }
    if([expenses count] > 0) {
        NSLog(@"Expenses: %@", expenses);
        self.expensesByDay = [[self groupExpensesByDate:expenses]retain];
        NSLog(@"%lu Expenses by Day: %@", (unsigned long)[self.expensesByDay count], self.expensesByDay);
        NSArray *unsortedDays = [self.expensesByDay allKeys];
        self.sortedDays = [[[unsortedDays sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
        NSLog(@"Sort by date: %@", self.sortedDays);
    
        [self.tableView reloadData];
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    [self launchReload];
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
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *expensesThisDay = [self.expensesByDay objectForKey:dateRepresentingThisDay];
    TransactionDomainObject *transaction = [expensesThisDay objectAtIndex:indexPath.row];
    
    SpendMoneyViewController* spendMoneyViewController = [[[SpendMoneyViewController alloc]initWithTransaction:transaction]autorelease];
    CategoryDomainObject* expenseCategory = transaction.is_a;
    spendMoneyViewController.category = expenseCategory;
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
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
