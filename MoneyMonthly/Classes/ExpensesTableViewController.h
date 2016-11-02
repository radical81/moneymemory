//
//  ExpensesTableViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 26/9/15.
//  Copyright © 2015 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDomainObject.h"
#import "ExpensesTableViewCell.h"
#import "CategoryUpdateDelegate.h"
#import "ExpenseUpdateDelegate.h"
#import "ExpenseDateFilterDelegate.h"
#import "HistoryMonthYearTableViewController.h"

@interface ExpensesTableViewController : UITableViewController <ExpenseUpdateDelegate, ExpenseDateFilterDelegate>
-(id) initWithAll;
-(id) initWithCategory:(CategoryDomainObject*) _category;

@property (retain, nonatomic) IBOutlet ExpensesTableViewCell *expensesTableViewCell;
@property(nonatomic, retain) id <CategoryUpdateDelegate> categoryDelegate;
@property (retain, nonatomic) HistoryMonthYearTableViewController* monthYearTable;

@end
