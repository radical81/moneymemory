//
//  SpendMoneyViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/12/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDomainObject.h"
#import "TransactionDomainObject.h"
#import "CategoryUpdateDelegate.h"
#import "ExpenseUpdateDelegate.h"

@interface SpendMoneyViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property(nonatomic, retain) id <CategoryUpdateDelegate> categoryDelegate;
@property(nonatomic, retain) id <ExpenseUpdateDelegate> expenseDelegate;
@property (nonatomic, retain) CategoryDomainObject* category;
@property (retain, nonatomic) IBOutlet UIImageView *background;
@property (retain, nonatomic) IBOutlet UITextField *transactionDateText;
@property (retain, nonatomic) IBOutlet UITextField *amountTextField;
- (void)didButtonPressSaveTransaction;
- (IBAction)takePicture:(id)sender;
- (IBAction)pictureFromLibrary:(id)sender;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *btnTakePictureWidth;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *btnPhotoLibraryWidth;
@property (retain, nonatomic) IBOutlet UIImageView *testImage;
@property (retain, nonatomic) IBOutlet UITextField *transactionComment;
- (IBAction)trashPicture:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *trashbutton;

- (id) initWithTransaction:(TransactionDomainObject*) transactionDomainObject;

@end
