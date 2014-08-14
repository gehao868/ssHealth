//
//  FriendListViewCell.m
//  HealthCoach
//
//  Created by Hao Ge on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "FriendListViewCell.h"

@implementation FriendListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
