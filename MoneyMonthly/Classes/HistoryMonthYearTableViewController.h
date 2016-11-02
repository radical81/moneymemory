//
//  HistoryMonthYearTableViewController.h
//  MoneyMonthly
//
//  Created by Rex Jason Alobba on 2/11/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpenseDateFilterDelegate.h"

@interface HistoryMonthYearTableViewController : UITableViewController

@property(nonatomic, retain) id <ExpenseDateFilterDelegate> historyTable;

- (id) initWithAll;

@end
