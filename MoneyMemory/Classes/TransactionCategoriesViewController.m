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

int const CELL_HEIGHT = 50;

TransactionsLogicManager* logicManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        logicManager = [[TransactionsLogicManager alloc]init];
        transactionCategories = [[logicManager fetchAllCategories] retain];
    }
    return self;
}

-(void) dealloc {
    if(logicManager) {
        [logicManager release];
        logicManager = nil;
    }
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryDomainObject* cat = [transactionCategories objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = cat.name;
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
    NSLog(@"transactionCategories before delete: %@",transactionCategories);
    NSLog(@"number of transactionCategories before delete: %lu",(unsigned long)[transactionCategories count]);
    CategoryDomainObject* cat = [transactionCategories objectAtIndex:indexPath.row];
    [logicManager deleteCategoryInCoreData:cat];
    NSLog(@"transactionCategories after delete: %@",transactionCategories);
    NSLog(@"Deleted row %d", (int)indexPath.row);
    transactionCategories = [[logicManager fetchAllCategories] retain];
    NSLog(@"number of transactionCategories after delete: %lu",(unsigned long)[transactionCategories count]);
    
    [tableView reloadData];
    
}

-(void) viewWillAppear:(BOOL)animated {
    transactionCategories = [[logicManager fetchAllCategories] retain];
    [self.tableView reloadData];
}

@end
