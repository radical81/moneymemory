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

@interface TransactionCategoriesViewController ()

@property(atomic,retain) IBOutlet UITableView* tblView;

@end

@implementation TransactionCategoriesViewController {
    NSArray* transactionCategories;
}

@synthesize tblView;
int const CELL_HEIGHT = 100;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        TransactionsLogicManager* logicManager = [[TransactionsLogicManager alloc]init];
        transactionCategories = [logicManager fetchCategoryNames];
        [logicManager release];
        tblView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        [self.view addSubview:tblView];
        self.tblView.dataSource = self;
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
    cellForRow.textLabel.text = [transactionCategories objectAtIndex:indexPath.row];
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



@end
