//
//  NewsFeedCell.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "NewsFeedCell.h"

@implementation NewsFeedCell {
    BOOL isLiked;
}

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

- (IBAction)liked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setImage:[UIImage imageNamed:@"circle_red"] forState:UIControlStateNormal];
    //btn.backgroundColor = [UIColor redColor];
}
@end
