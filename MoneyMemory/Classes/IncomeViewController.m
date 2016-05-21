//
//  IncomeViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 25/5/15.
//  Copyright (c) 2015 Rex Jason Alobba. All rights reserved.
//

#import "IncomeViewController.h"
#import "TransactionsLogicManager.h"

@interface IncomeViewController ()

@end

@implementation IncomeViewController {
    TransactionsLogicManager* transactionsLogicManager;
    BOOL incomeSave;
}

@synthesize incomeAmount = _incomeAmount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _incomeAmount.text = [NSString stringWithFormat:@"%.0f",[transactionsLogicManager retrieveIncomeMonthly]];
    self.navigationItem.title = @"My Income";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didTapSaveIncome)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapSaveIncome {
    double amount = [_incomeAmount.text doubleValue];
    if(amount == 0) {
        [self showAlertMissingDetails:YES];
        return;
    }
    
    [self createNotificationObserver];
    [transactionsLogicManager updateIncomeMonthly:amount];
    [self showAlertSavedIncome:incomeSave];
}

-(void) showAlertMissingDetails:(BOOL) amountMissing {
    
    NSString* errorMessage = @"";
    
    if(amountMissing) {
        errorMessage = [errorMessage stringByAppendingString:@"Amount is missing.\n"];
    }
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Cannot Save Income"
                                  message: errorMessage
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

-(void) createNotificationObserver {
    incomeSave = NO;
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
                                  incomeSave = YES;
                              }
                          }];
}

-(void) showAlertSavedIncome:(BOOL) success {
    NSString* alertMessage;
    
    if(success == YES) {
        alertMessage = @"Your income has been updated.";
    }
    else {
        alertMessage = @"Failed to update your income. Please try again.";
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Save Income"
                                  message: alertMessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self.navigationController popViewControllerAnimated:YES];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_incomeAmount release];
    [transactionsLogicManager release];
    [super dealloc];
}
@end
