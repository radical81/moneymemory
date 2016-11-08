//
//  TransactionCategoriesViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 11/2/14.
//  Copyright (c) 2014 Rex Jason Alobba. All rights reserved.
//

#import "TransactionCategoriesViewController.h"
#import "TransactionsLogicManager.h"
#import "CategoryDomainObject.h"
#import "CategoryDetailViewController.h"

#import "AddCategoryViewController.h"

@interface TransactionCategoriesViewController ()


@property(nonatomic, retain) NSArray* transactionCategories;

@end

@implementation TransactionCategoriesViewController


@synthesize transactionCategories;
@synthesize categoryCell = _categoryCell;

int const CELL_HEIGHT = 120;

TransactionsLogicManager* logicManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        logicManager = [[TransactionsLogicManager alloc]init];
        transactionCategories = [[logicManager fetchCurrentCategories] retain];
    }
    return self;
}

-(void) dealloc {
    if(logicManager) {
        [logicManager release];
        logicManager = nil;
    }
    [_categoryCell release];
    [super dealloc];
}

- (void)addTransactionCategory {
    AddCategoryViewController* addCategoryViewController = [[AddCategoryViewController alloc]init];
    [self.navigationController pushViewController:addCategoryViewController animated:YES];
    [addCategoryViewController release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTransactionCategory)];
    self.navigationItem.rightBarButtonItem = rightButton;

    [rightButton release];
    self.navigationItem.title = @"Categories";
    self.tableView.separatorColor = [UIColor clearColor];
}

-(void) addLabelForEmpty {
    UILabel *tableEmpty = [[UILabel alloc] init];
    [tableEmpty setTextColor:[UIColor lightGrayColor]];
    [tableEmpty setText:@"Tap the + button to add a category."];
    [tableEmpty sizeToFit];
    [tableEmpty setTextAlignment:NSTextAlignmentCenter];
    tableEmpty.frame = CGRectMake(0, 0, tableEmpty.bounds.size.width, tableEmpty.bounds.size.height);
    self.tableView.backgroundView = tableEmpty;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor*) percentageColor:(double) percent {
    if(percent > 90) {
        NSLog(@"red");
        return [UIColor redColor];
    }
    if(percent > 50) {
        NSLog(@"orange");
        return [UIColor orangeColor];
    }
    NSLog(@"Green");
    return [UIColor colorWithRed:(85/255.f) green:(107/255.f) blue:(47/255.f) alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryDomainObject* cat = [transactionCategories objectAtIndex:indexPath.row];
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[CategoryTableViewCell reuseIdentifier]];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
        cell = _categoryCell;
        _categoryCell = nil;
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setAllowsFloats:YES];
    [formatter setMaximumFractionDigits:2];
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @",";
    NSString* categoryLimit = [NSString stringWithFormat:@"$ %@", [formatter stringFromNumber:cat.limit]];
    NSNumber* totalForCategory = [logicManager calculateTotalForCategory:[cat.id intValue] _givenDate:[NSDate date]];
    NSString* totalExpensesAmount = [NSString stringWithFormat:@"$ %@", [formatter stringFromNumber:totalForCategory]];
    
    
    double percentage = [totalForCategory floatValue]  / ([cat.limit floatValue] / 100.0);
    cell.nameLabel.text = cat.name;
    cell.limitLabel.text = [NSString stringWithFormat:@"Limit: %@", categoryLimit];
    cell.totalLabel.text = [NSString stringWithFormat:@"Spent: %@", totalExpensesAmount];
    NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc] init];
    [percentFormatter setMaximumFractionDigits:0];
    [percentFormatter setRoundingMode: NSNumberFormatterRoundDown];
    
    NSString *percentString = [percentFormatter stringFromNumber:[NSNumber numberWithFloat:percentage]];
    [formatter release];
    cell.percentLabel.text = [NSString stringWithFormat:@"%@%%", percentString];
    cell.percentLabel.textColor = [self percentageColor:percentage];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [transactionCategories count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryDomainObject* cat = [transactionCategories objectAtIndex:indexPath.row];
    CategoryDetailViewController* categoryDetail = [[[CategoryDetailViewController alloc]initWithNibName:@"CategoryDetailViewController" bundle:nil]autorelease];
    categoryDetail.category = cat;
    [self.navigationController pushViewController:categoryDetail animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController* confirmDelete = [UIAlertController alertControllerWithTitle:@"Confirm Delete"
                                                          message:@"All expenses in this category will be lost. Do you want to proceed? You can also choose Hide to preserve old expenses."
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [confirmDelete addAction:[UIAlertAction actionWithTitle:@"Delete"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                NSLog(@"transactionCategories before delete: %@",transactionCategories);
                                                NSLog(@"number of transactionCategories before delete: %lu",(unsigned long)[transactionCategories count]);
                                                CategoryDomainObject* cat = [transactionCategories objectAtIndex:indexPath.row];
                                                [logicManager deleteCategoryInCoreData:cat];
                                                NSLog(@"transactionCategories after delete: %@",transactionCategories);
                                                NSLog(@"Deleted row %d", (int)indexPath.row);
                                                transactionCategories = [[logicManager fetchCurrentCategories] retain];
                                                NSLog(@"number of transactionCategories after delete: %lu",(unsigned long)[transactionCategories count]);
                                                [tableView reloadData];
                                            }
                              ]
     ];
    [confirmDelete addAction:[UIAlertAction actionWithTitle:@"Hide"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        NSLog(@"Hide category");
                                                        CategoryDomainObject* cat = [transactionCategories objectAtIndex:indexPath.row];
                                                        cat.visible = NO;
                                                        [logicManager updateCategory:cat];
                                                        transactionCategories = [[logicManager fetchCurrentCategories] retain];
                                                        NSLog(@"number of transactionCategories after hide: %lu",(unsigned long)[transactionCategories count]);
                                                        [tableView reloadData];
                                                    }
                              ]
     ];
    [confirmDelete addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                            style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {}
                              ]
     ];

    [self presentViewController:confirmDelete animated:YES completion:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    transactionCategories = [[logicManager fetchCurrentCategories] retain];
    [self.tableView reloadData];
    if([transactionCategories count] > 0) {
        self.tableView.backgroundView = nil;
    }
    else {
        [self addLabelForEmpty];
    }
}

@end
