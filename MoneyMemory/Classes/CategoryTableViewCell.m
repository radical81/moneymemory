//
//  CategoryTableViewCell.m
//  MoneyMemory
//
//  Created by Rex Jason Alobba on 23/5/16.
//  Copyright © 2016 Rex Jason Alobba. All rights reserved.
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

@synthesize nameLabel = _nameLabel;
@synthesize  limitLabel = _limitLabel;
@synthesize totalLabel = _totalLabel;
@synthesize percentLabel = _percentLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier {
    return @"CategoryCellIdentifier";
}

- (void)dealloc {
    [_nameLabel release];
    [_limitLabel release];
    [_totalLabel release];
    [_percentLabel release];
    [super dealloc];
}
@end
