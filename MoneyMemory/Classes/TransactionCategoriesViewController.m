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
#import "SpendMoneyViewController.h"

@interface TransactionCategoriesViewController ()

@property(atomic,retain) IBOutlet UITableView* tblView;
@property(nonatomic, retain) NSArray* transactionCategories;

@end

@implementation TransactionCategoriesViewController

@synthesize tblView;
@synthesize transactionCategories;

int const CELL_HEIGHT = 50;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        TransactionsLogicManager* logicManager = [[TransactionsLogicManager alloc]init];
        transactionCategories = [[logicManager fetchAllCategories] retain];
        [logicManager release];
    }
    return self;
}

-(void) dealloc {
    if(tblView) {
        [tblView release];
        tblView = nil;
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cellForRow = [[[UITableViewCell alloc]init]autorelease];
    CategoryDomainObject* cat = [transactionCategories objectAtIndex:indexPath.row];
    cellForRow.textLabel.text = cat.name;
    return  cellForRow;
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

    SpendMoneyViewController* spendMoneyViewController = [[[SpendMoneyViewController alloc]initWithNibName:@"SpendMoneyViewController" bundle:nil]autorelease];
    spendMoneyViewController.transactionCategory = cat.id;
    spendMoneyViewController.transactionCategoryText =  cat.name;
    [self.navigationController pushViewController:spendMoneyViewController animated:YES];
}


@end
