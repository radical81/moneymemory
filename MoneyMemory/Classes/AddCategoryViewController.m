//
//  AddCategoryViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 21/5/14.
//  Copyright (c) 2014 Rex Jason Alobba. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "TransactionsLogicManager.h"
#import "CategoryDomainObject.h"

@interface AddCategoryViewController ()

@end

@implementation AddCategoryViewController

TransactionsLogicManager* transactionsLogicManager;


@synthesize categoryNew = _categoryNew;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _categoryNew = [[UITextField alloc]init];
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
        
    }
    return self;
}

- (IBAction)didTapSave:(id)sender {
    NSLog(@"Save tapped %@", _categoryNew.text);
    CategoryDomainObject* category = [[CategoryDomainObject alloc]init];
    int latestCategoryId = [transactionsLogicManager retrieveLatestCategoryId];
    latestCategoryId++;
    category.id = [NSNumber numberWithInt:latestCategoryId];
    category.name = _categoryNew.text;
    category.limit = [NSNumber numberWithInt: 100];
    [transactionsLogicManager saveCategoryToCoreData:category];
    [category release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_categoryNew release];
    [transactionsLogicManager release];
    [super dealloc];
}
@end
