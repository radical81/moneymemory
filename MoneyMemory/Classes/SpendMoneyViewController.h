//
//  SpendMoneyViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/12/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpendMoneyViewController : UIViewController
@property  (nonatomic, retain) NSNumber* transactionCategory;
@property (nonatomic, retain) NSString* transactionCategoryText;
@property (retain, nonatomic) IBOutlet UILabel *transactionType;
@end
