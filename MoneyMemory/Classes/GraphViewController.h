//
//  GraphViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 24/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *headerLabel;
@property (retain, nonatomic) IBOutlet UILabel *monthTotal;
@property (retain, nonatomic) IBOutlet UILabel *categoryPercent;

@end
