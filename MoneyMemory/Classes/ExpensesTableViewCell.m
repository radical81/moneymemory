//
//  ExpensesTableViewCell.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 24/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "ExpensesTableViewCell.h"

@implementation ExpensesTableViewCell

@synthesize photoView = _photoView;
@synthesize amountLabel = _amountLabel;
@synthesize descriptionLabel = _descriptionLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_photoView release];
    [_amountLabel release];
    [_descriptionLabel release];
    [super dealloc];
}

+ (NSString *)reuseIdentifier {
    return @"ExpensesCellIdentifier";
}

@end
