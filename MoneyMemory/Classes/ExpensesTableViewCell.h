//
//  ExpensesTableViewCell.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 24/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpensesTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *photoView;
@property (retain, nonatomic) IBOutlet UILabel *amountLabel;
@property (retain, nonatomic) IBOutlet UILabel *descriptionLabel;

+ (NSString *)reuseIdentifier;

@end
