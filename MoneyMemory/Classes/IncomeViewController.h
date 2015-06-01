//
//  IncomeViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 25/5/15.
//  Copyright (c) 2015 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *incomeAmount;
- (IBAction)didTapSaveIncome:(id)sender;

@end
