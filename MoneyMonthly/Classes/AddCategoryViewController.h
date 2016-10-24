//
//  AddCategoryViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 21/5/14.
//  Copyright (c) 2014 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDomainObject.h"

@interface AddCategoryViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UILabel *pageLabel;
@property (retain, nonatomic) IBOutlet UITextField *categoryNew;
@property (retain, nonatomic) IBOutlet UITextField *amountLimit;
@property (retain, nonatomic) IBOutlet UIImageView *background;

- (id) initWithCategory: (CategoryDomainObject*) category;

@end
