//
//  SpendMoneyViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/12/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "SpendMoneyViewController.h"
#import "TransactionDomainObject.h"
#import "TransactionsLogicManager.h"
#import "CameraViewController.h"

@interface SpendMoneyViewController ()

@end

@implementation SpendMoneyViewController {
    TransactionsLogicManager* transactionsLogicManager;
    BOOL transactionSave;
}

@synthesize category = _category;
@synthesize transactionType = _transactionType;
@synthesize transactionDate = _transactionDate;
@synthesize amountTextField = _amountTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_transactionType setText:_category.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) hideKeyboard:(id)sender {
    [_amountTextField resignFirstResponder];
}

- (void)dealloc {
    [_category release];
    [_transactionType release];
    [_transactionDate release];
    [_amountTextField release];
    [transactionsLogicManager release];
    [super dealloc];
}


- (IBAction)didButtonPressSaveTransaction:(id)sender {
    TransactionDomainObject *transaction = [[TransactionDomainObject alloc]init];
    int latestTransactionId = [transactionsLogicManager retrieveLatestTransactionId];
    latestTransactionId++;
    transaction.id = [NSNumber numberWithInt:latestTransactionId];
    transaction.amount = [NSNumber numberWithDouble:[_amountTextField.text doubleValue]];
    if([transaction.amount doubleValue] > [_category.limit doubleValue]) {
        [self showOverShotTransaction:[_category.limit stringValue]];
        return;
    }
    NSNumber* totalForCategory = [transactionsLogicManager calculateTotalForCategory:[_category.id intValue]];
    double total = [totalForCategory doubleValue] + [_amountTextField.text doubleValue];
    if(total > [_category.limit doubleValue]) {
        [self showOverShotTransaction:[_category.limit stringValue]];
        return;
    }    
    NSNumber* timeStamp = [NSNumber numberWithDouble:[_transactionDate.date timeIntervalSince1970]];
    
    transaction.timestamp = timeStamp;
    
    NSLog(@"Saved with Timestamp: %@", transaction.timestamp);
    
    [self createNotificationObserver];
    [transactionsLogicManager saveTransactionToCoreData:transaction withCategory:_category];
    [transaction release];

    [self showAlertSavedTransaction:transactionSave];
}

- (IBAction)takePhoto:(id)sender {
    CameraViewController* cameraViewController = [[[CameraViewController alloc]initWithNibName:@"CameraViewController" bundle:nil]autorelease];
    [self.navigationController pushViewController:cameraViewController animated:YES];
}

-(void) createNotificationObserver {
    transactionSave = NO;
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
                                            transactionSave = YES;
                                    }
                          }];
}

-(void) showOverShotTransaction:(NSString*) transactionLimit {
    NSString* alertMessage;
    
    alertMessage = [NSString stringWithFormat:@"You can only spend up to $%@",transactionLimit];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Save Transaction"
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

-(void) showAlertSavedTransaction:(BOOL) success {
    NSString* alertMessage;
    
    if(success == YES) {
        alertMessage = @"The transaction has been saved.";
    }
    else {
        alertMessage = @"Failed to save transaction. Please try again.";
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Save Transaction"
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

@end
