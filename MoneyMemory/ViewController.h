//
//  ViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 16/9/13.
//  Copyright (c) 2013 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *spendButton;

-(IBAction)spendButtonClicked:(id)sender;

@end
