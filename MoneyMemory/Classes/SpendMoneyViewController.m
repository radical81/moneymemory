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
@property (nonatomic, retain) NSURL* imgUrl;

@end

@implementation SpendMoneyViewController {
    TransactionsLogicManager* transactionsLogicManager;
    BOOL transactionSave;
}

@synthesize category = _category;
@synthesize transactionType = _transactionType;
@synthesize transactionDate = _transactionDate;
@synthesize amountTextField = _amountTextField;
@synthesize testImage = _testImage;
@synthesize newMedia = _newMedia;
@synthesize imgUrl = _imgUrl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        transactionsLogicManager = [[TransactionsLogicManager alloc]init];
    }
    return self;
}

- (void) loadDefaultImage {
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *rep = [myasset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        if (iref) {
            _testImage.image = [UIImage imageWithCGImage:iref];
            [_testImage.image retain];
        }
    };
    
    //
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
    {
        NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
    };
    NSString *mediaurl = @"assets-library://asset/asset.JPG?id=ECE6189E-341E-479C-A4D6-03EDD5F2D31B&ext=JPG";
    if(mediaurl && [mediaurl length]) {
        [_testImage.image release];
        NSURL *asseturl = [NSURL URLWithString:mediaurl];
        ALAssetsLibrary* assetslibrary = [[[ALAssetsLibrary alloc] init] autorelease];
        [assetslibrary assetForURL:asseturl
                       resultBlock:resultblock
                      failureBlock:failureblock];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_transactionType setText:_category.name];
    [self loadDefaultImage];
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
    [_testImage release];
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

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        _testImage.image = image;
        if (_newMedia) {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            // Request to save the image to camera roll
            [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
                if (error) {
                    NSLog(@"error");
                } else {
                    NSLog(@"url %@", assetURL);
                    _imgUrl = assetURL;
                }
            }];
            [library release];
        }
        else {
            NSURL *imageUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
            NSLog(@"image url: %@", imageUrl);
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
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
