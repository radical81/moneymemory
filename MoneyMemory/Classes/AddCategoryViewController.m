//
//  AddCategoryViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 21/5/14.
//  Copyright (c) 2014 Rex Jason Alobba. All rights reserved.
//

#import "AddCategoryViewController.h"
#import "TransactionsLogicManager.h"

@interface AddCategoryViewController ()

@property (nonatomic, retain) CategoryDomainObject* category;

@end

@implementation AddCategoryViewController

TransactionsLogicManager* transactionsLogicManager;
BOOL categorySave;
BOOL isAddCategory;
@synthesize category = _category;
@synthesize pageLabel = _pageLabel;
@synthesize categoryNew = _categoryNew;
@synthesize amountLimit = _amountLimit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _categoryNew = [[UITextField alloc]init];
        _amountLimit = [[UITextField alloc] init];
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
        isAddCategory = YES;
    }
    return self;
}

- (id) initWithCategory: (CategoryDomainObject*) category {
    self = [super initWithNibName:@"AddCategoryViewController" bundle:nil];
    if (self) {
        // Custom initialization
        _category = category;
        _categoryNew = [[UITextField alloc]init];
        _amountLimit = [[UITextField alloc] init];
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
        isAddCategory = NO;
    }
    return self;
    
}

- (void) addNewCategory {
    NSLog(@"Add New Category");
    CategoryDomainObject* category = [[CategoryDomainObject alloc]init];
    int latestCategoryId = [transactionsLogicManager retrieveLatestCategoryId];
    latestCategoryId++;
    category.id = [NSNumber numberWithInt:latestCategoryId];
    category.name = _categoryNew.text;
    category.limit = [NSNumber numberWithDouble:[_amountLimit.text doubleValue]];
    NSNumber* totalOfCategories = [transactionsLogicManager calculateTotalOfCategories];
    double total = [totalOfCategories doubleValue] + [_amountLimit.text doubleValue];
    double monthlyIncome = [transactionsLogicManager retrieveIncomeMonthly];
    if(total > monthlyIncome) {
        [self showOverShotBudget:[NSString stringWithFormat:@"%.0f", monthlyIncome]];
        return;
    }
    [self createNotificationObserver];
    [transactionsLogicManager saveCategoryToCoreData:category];
    [category release];
    [self showAlertSavedCategory:categorySave];
}

-(void) updateCategory {
    NSLog(@"Update Category");
    _category.name = _categoryNew.text;
    _category.limit = [NSNumber numberWithDouble:[_amountLimit.text doubleValue]];
    NSNumber* totalOfCategories = [transactionsLogicManager calculateTotalOfCategories];
    double totalCategoriesInDouble = [totalOfCategories doubleValue];
    totalCategoriesInDouble = totalCategoriesInDouble - [_category.limit doubleValue];
    double total = totalCategoriesInDouble + [_amountLimit.text doubleValue];
    double monthlyIncome = [transactionsLogicManager retrieveIncomeMonthly];
    if(total > monthlyIncome) {
        [self showOverShotBudget:[NSString stringWithFormat:@"%.0f", monthlyIncome]];
        return;
    }
    [self createNotificationObserver];
    [transactionsLogicManager updateCategory:_category];
    [self showAlertSavedCategory:categorySave];    
}

- (IBAction)didTapSave:(id)sender {
    NSLog(@"Save tapped %@", _categoryNew.text);
    if(isAddCategory == YES) {
        [self addNewCategory];
    }
    else {
        [self updateCategory];
    }
}

-(void) createNotificationObserver {
    categorySave = NO;
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter addObserverForName:nil
                              object:nil
                               queue:nil
                          usingBlock:^(NSNotification* notification){
                              // Explore notification
                              //                              NSLog(@"Notification found with:"
                              //                                    "\r\n     name:     %@"
                              //                                    "\r\n     object:   %@"
                              //                                    "\r\n     userInfo: %@",
                              //                                    [notification name],
                              //                                    [notification object],
                              //                                    [notification userInfo]);
                              if([[notification name] isEqualToString:@"NSManagingContextDidSaveChangesNotification"]) {
                                  categorySave = YES;
                              }
                          }];
}

-(void) showAlertSavedCategory:(BOOL) success {
    NSString* alertMessage;
    
    if(success == YES) {
        alertMessage = @"The category has been saved.";
    }
    else {
        alertMessage = @"Failed to save category. Please try again.";
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Save Category"
                                  message: alertMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self.navigationController popViewControllerAnimated:YES];
                             NSUInteger indices = [self.navigationController.viewControllers count];                             
                             indices--;
                             [[self.navigationController.viewControllers objectAtIndex:indices] setTitle: _category.name];
                             
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) showOverShotBudget:(NSString*) incomeLimit {
    NSString* alertMessage;
    
    alertMessage = [NSString stringWithFormat:@"Your monthly budget is over $%@",incomeLimit];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Save Category"
                                  message: alertMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) showCategoryDetails {
    _categoryNew.text = _category.name;
    _amountLimit.text = [_category.limit stringValue];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(isAddCategory == NO) {
        [self showCategoryDetails];
        _pageLabel.text = @"Update Category";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_categoryNew release];
    [_amountLimit release];
    [transactionsLogicManager release];
    [_pageLabel release];
    [super dealloc];
}
@end
