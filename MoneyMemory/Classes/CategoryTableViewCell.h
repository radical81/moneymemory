//
//  CategoryTableViewCell.h
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *limitLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalLabel;
@property (retain, nonatomic) IBOutlet UILabel *percentLabel;

+ (NSString *)reuseIdentifier;

@end
