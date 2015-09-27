//
//  ExpensesTableViewController.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 26/9/15.
//  Copyright © 2015 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDomainObject.h"

@interface ExpensesTableViewController : UITableViewController

-(id) initWithCategory:(CategoryDomainObject*) category;
@end
