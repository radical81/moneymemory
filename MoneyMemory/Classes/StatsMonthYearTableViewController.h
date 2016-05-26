//
//  StatsMonthYearTableViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 26/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsMonthYearDelegate.h"

@interface StatsMonthYearTableViewController : UITableViewController

@property(nonatomic, retain) id <StatsMonthYearDelegate> graphDisplay;
- (id) initWithAll;

@end
