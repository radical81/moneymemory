//
//  SpendMoneyViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/12/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDomainObject.h"

@interface SpendMoneyViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) CategoryDomainObject* category;
@property (retain, nonatomic) IBOutlet UILabel *transactionType;
@property (retain, nonatomic) IBOutlet UIDatePicker *transactionDate;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;
- (IBAction)didButtonPressSaveTransaction:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)pictureFromLibrary:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *testImage;

@end
