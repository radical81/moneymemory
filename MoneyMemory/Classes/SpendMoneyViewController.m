//
//  SpendMoneyViewController.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/12/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import "SpendMoneyViewController.h"
#import "TransactionsLogicManager.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SpendMoneyViewController ()

@property (nonatomic, retain) TransactionDomainObject* transaction;
@property BOOL newTransaction;
@property BOOL newMedia;

@property (nonatomic, retain) NSString* imageFilename;

@end

@implementation SpendMoneyViewController {
    TransactionsLogicManager* transactionsLogicManager;
    UIDatePicker *transactionDatePicker;
    BOOL transactionSave;
}

@synthesize category = _category;
@synthesize transaction = _transaction;
@synthesize transactionType = _transactionType;
@synthesize transactionDateText = _transactionDateText;
@synthesize amountTextField = _amountTextField;
@synthesize testImage = _testImage;
@synthesize transactionComment = _transactionComment;
@synthesize newTransaction = _newTransaction;
@synthesize newMedia = _newMedia;
@synthesize imageFilename;
@synthesize trashbutton = _trashbutton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
        _newTransaction = YES;
    }
    return self;
}

- (id) initWithTransaction:(TransactionDomainObject*) transactionDomainObject {
    self = [super initWithNibName:@"SpendMoneyViewController" bundle:nil];
    if (self) {
        // Custom initialization
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
        _transaction = transactionDomainObject;
        _newTransaction = NO;
    }
    return self;
}

- (void) imageViewTapEventSetup {
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTapImage)] autorelease];
    singleTap.numberOfTapsRequired = 1;
    [_testImage setUserInteractionEnabled:YES];
    [_testImage addGestureRecognizer:singleTap];
}

- (void) showTransactionDetails {
    _amountTextField.text = [_transaction.amount stringValue];
    _transactionComment.text = _transaction.comment;
    if(_transaction.imagepath != NULL) {
        _testImage.hidden = NO;
        _trashbutton.hidden = NO;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = paths.firstObject;
        NSString *imageSavedPath = [basePath stringByAppendingPathComponent:_transaction.imagepath];
        
        _testImage.image = [UIImage imageWithContentsOfFile:imageSavedPath];
        self.imageFilename = _transaction.imagepath;
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *transactionDate = [NSDate dateWithTimeIntervalSince1970:[_transaction.timestamp doubleValue]];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:transactionDate];
    [dateFormat release];
    _transactionDateText.text = [NSString stringWithFormat:@"%@",dateString];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_transactionType setText:_category.name];

    _testImage.hidden = YES;
    _trashbutton.hidden = YES;
    
    if(_newTransaction == NO) {
        [self showTransactionDetails];
    }
    [self datePickerSetup];
    _transactionComment.autocapitalizationType = UITextAutocapitalizationTypeSentences;
}

-(void) datePickerSetup {
    transactionDatePicker = [[UIDatePicker alloc] init];
    transactionDatePicker.datePickerMode = UIDatePickerModeDate;
    [transactionDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_transactionDateText setInputView:transactionDatePicker];
    
    UIToolbar* dateToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    [dateToolBar setTintColor:[UIColor grayColor]];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(dismissDatePicker:)];
    [dateToolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    [_transactionDateText setInputAccessoryView:dateToolBar];
}

-(void) fillDefaultDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *dateNow = [NSDate date];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:dateNow];
    [dateFormat release];
    _transactionDateText.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void) dismissDatePicker:(id) sender {
    if(_transactionDateText.text.length < 1) {
        [self fillDefaultDate];
    }
    [_transactionDateText resignFirstResponder];
}

-(void) doSingleTapImage {
    [self pictureFromLibrary:self];
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
    [_transaction release];
    [_category release];
    [_transactionType release];
    [_amountTextField release];
    [transactionsLogicManager release];
    [_testImage release];
    [self.imageFilename release];
    [transactionDatePicker release];
    [_transactionDateText release];
    [_trashbutton release];
    [_transactionComment release];
    [super dealloc];
}


-(void) datePickerValueChanged:(id) sender {
    UIDatePicker *picker = (UIDatePicker*)_transactionDateText.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    [dateFormat release];
    _transactionDateText.text = [NSString stringWithFormat:@"%@",dateString];
}

-(void) saveNewTransaction:(NSNumber*) timeStamp {
    TransactionDomainObject* transaction = [[TransactionDomainObject alloc]init];
    int latestTransactionId = [transactionsLogicManager retrieveLatestTransactionId];
    latestTransactionId++;
    transaction.id = [NSNumber numberWithInt:latestTransactionId];
    
    transaction.amount = [NSNumber numberWithDouble:[_amountTextField.text doubleValue]];
    if([transaction.amount doubleValue] > [_category.limit doubleValue]) {
        [self showOverShotTransaction:[_category.limit stringValue]];
        return;
    }
    
    transaction.timestamp = timeStamp;
    
    NSLog(@"Saved with Timestamp: %@", transaction.timestamp);
    
    transaction.imagepath = self.imageFilename;
    
    NSLog(@"Filename of image: %@", transaction.imagepath);
    
    transaction.comment = _transactionComment.text;
    
    NSLog(@"Remarks: %@", transaction.comment);
    
    [self createNotificationObserver];
    [transactionsLogicManager saveTransactionToCoreData:transaction withCategory:_category];
    [transaction release];
    
    [self showAlertSavedTransaction:transactionSave];
}

-(void) updateTransaction:(NSNumber*) timeStamp {
    _transaction.amount = [NSNumber numberWithDouble:[_amountTextField.text doubleValue]];
    if([_transaction.amount doubleValue] > [_category.limit doubleValue]) {
        [self showOverShotTransaction:[_category.limit stringValue]];
        return;
    }
    
    _transaction.timestamp = timeStamp;
    
    NSLog(@"Saved with Timestamp: %@", _transaction.timestamp);
    
    _transaction.imagepath = self.imageFilename;
    
    NSLog(@"Updated filename of image: %@", _transaction.imagepath);
    
    _transaction.comment = _transactionComment.text;
    
    NSLog(@"Remarks: %@", _transaction.comment);
    
    [self createNotificationObserver];
    [transactionsLogicManager updateTransaction:_transaction];
    
    [self showAlertSavedTransaction:transactionSave];
    
}

- (IBAction)didButtonPressSaveTransaction:(id)sender {

    BOOL isAmountNil = NO;
    BOOL isDateNil = NO;
    if([_amountTextField.text doubleValue] == 0) {
        isAmountNil = YES;
    }
    if([_transactionDateText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        isDateNil = YES;
    }
    if(isAmountNil == YES || isDateNil == YES) {
        [self showAlertMissingDetails:isAmountNil _dateMissing:isDateNil];
        return;
    }
    NSNumber* totalForCategory = [transactionsLogicManager calculateTotalForCategory:[_category.id intValue]];
    double total = [totalForCategory doubleValue] + [_amountTextField.text doubleValue];
    if(total > [_category.limit doubleValue]) {
        [self showOverShotTransaction:[_category.limit stringValue]];
        return;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate* transactionDate = [dateFormat dateFromString:_transactionDateText.text];
    [dateFormat release];
    NSNumber* timeStamp = [NSNumber numberWithDouble:[transactionDate timeIntervalSince1970]];
    
    if(_newTransaction == YES) {
        [self saveNewTransaction: timeStamp];
    }
    else {
        [self updateTransaction:timeStamp];
    }
}

- (IBAction)takePicture:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = YES;
    }

}
- (IBAction)pictureFromLibrary:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
        _newMedia = NO;
    }
}

- (IBAction)trashPicture:(id)sender {
    NSLog(@"trashPicture");
    if(_testImage.image == nil) {
        return;
    }
    NSLog(@"Test image not nil, delete...");
    _testImage.image = nil;
    _testImage.hidden = YES;
    [_testImage setUserInteractionEnabled:NO];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    
    NSString *imageSavedPath = [basePath stringByAppendingPathComponent:self.imageFilename];

    NSLog(@"About to delete %@ ...", imageSavedPath);
    
    BOOL success = [fileManager removeItemAtPath:imageSavedPath error:&error];
    if (success) {
        NSLog(@"Deleted %@", imageSavedPath);
    }
    else {
        NSLog(@"Could not delete file - %@", [error localizedDescription]);
    }
    self.imageFilename = nil;
    _trashbutton.hidden = YES;
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

-(void) showAlertMissingDetails:(BOOL) amountMissing _dateMissing: (BOOL) dateMissing {
    
    NSString* errorMessage = @"";
    
    if(amountMissing) {
        errorMessage = [errorMessage stringByAppendingString:@"Amount is missing.\n"];
    }
    if(dateMissing) {
        errorMessage = [errorMessage stringByAppendingString:@"Date is blank.\n"];
    }
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Cannot Save Transaction"
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

-(void) storeImageFilename:(UIImage*) newImage {
    NSData *imageData = UIImagePNGRepresentation(newImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *imageFile = [NSString stringWithFormat:@"%@.png", timestamp];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:imageFile];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");

    }

    self.imageFilename = imageFile;
    NSLog(@"Filename of image: %@",self.imageFilename);
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        //Image file path
        [self storeImageFilename:image];
        _testImage.hidden = NO;
        _testImage.image = image;
        [_testImage setContentMode:UIViewContentModeScaleAspectFit];
        _testImage.layer.zPosition = -1;
        [self imageViewTapEventSetup];
        _trashbutton.hidden = NO;
        

        if (_newMedia) {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            // Request to save the image to camera roll
            [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    NSLog(@"error");
                } else {
                    NSLog(@"url %@", assetURL);

                }
            }];
            [library release];
        }
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
