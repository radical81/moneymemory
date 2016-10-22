//
//  GraphViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 24/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "StatsMonthYearTableViewController.h"
#import "StatsMonthYearDelegate.h"

@interface GraphViewController : UIViewController <PNChartDelegate, StatsMonthYearDelegate>
@property (retain, nonatomic) IBOutlet UILabel *headerLabel;
@property (retain, nonatomic) IBOutlet UILabel *monthTotal;
@property (retain, nonatomic) IBOutlet UILabel *categoryPercent;
@property (retain, nonatomic) IBOutlet UILabel *clickedLabel;
@property (retain, nonatomic) IBOutlet UILabel *tipLabel;
@property (retain, nonatomic) StatsMonthYearTableViewController* monthYearTable;

@end
