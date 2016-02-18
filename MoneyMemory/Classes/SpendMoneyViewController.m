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
#import "AssetsLibrary/AssetsLibrary.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SpendMoneyViewController ()

@property BOOL newMedia;
@property (nonatomic, retain) NSString* imageSavedPath;


@end

@implementation SpendMoneyViewController {
    TransactionsLogicManager* transactionsLogicManager;
    UIDatePicker *transactionDatePicker;
    BOOL transactionSave;
}

@synthesize category = _category;
@synthesize transactionType = _transactionType;
@synthesize transactionDateText = _transactionDateText;
@synthesize amountTextField = _amountTextField;
@synthesize testImage = _testImage;
@synthesize newMedia = _newMedia;
@synthesize imageSavedPath;
@synthesize trashbutton = _trashbutton;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
    }
    return self;
}

- (void) imageViewTapEventSetup {
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSingleTapImage)] autorelease];
    singleTap.numberOfTapsRequired = 1;
    [_testImage setUserInteractionEnabled:YES];
    [_testImage addGestureRecognizer:singleTap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_transactionType setText:_category.name];
    [self datePickerSetup];
    [self imageViewTapEventSetup];
    _trashbutton.hidden = YES;
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
    [_category release];
    [_transactionType release];
    [_amountTextField release];
    [transactionsLogicManager release];
    [_testImage release];
    [self.imageSavedPath release];
    [transactionDatePicker release];
    [_transactionDateText release];
    [_trashbutton release];
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
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSDate* transactionDate = [dateFormat dateFromString:_transactionDateText.text];
    [dateFormat release];
    NSNumber* timeStamp = [NSNumber numberWithDouble:[transactionDate timeIntervalSince1970]];
    
    transaction.timestamp = timeStamp;
    
    NSLog(@"Saved with Timestamp: %@", transaction.timestamp);
    
    transaction.imagepath = self.imageSavedPath;
    NSLog(@"Path to image: %@", self.imageSavedPath);

    [self createNotificationObserver];
    [transactionsLogicManager saveTransactionToCoreData:transaction withCategory:_category];
    [transaction release];

    [self showAlertSavedTransaction:transactionSave];
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
    _testImage.image = nil;
    self.imageSavedPath = nil;
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

-(void) retrieveImageFilePath:(UIImage*) newImage {
    NSData *imageData = UIImagePNGRepresentation(newImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", timestamp]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");

    }

    self.imageSavedPath = imagePath;
    NSLog(@"Path to image: %@",self.imageSavedPath);
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
        [self retrieveImageFilePath:image];
        _testImage.image = image;
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
