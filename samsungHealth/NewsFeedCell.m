//
//  NewsFeedCell.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "NewsFeedCell.h"
#import <Parse/Parse.h>
#import "UserData.h"

@implementation NewsFeedCell

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
    [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)liked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setEnabled:NO];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"heart_filled"] forState:UIControlStateNormal];
    self.likeNum.text = [NSString stringWithFormat:@"%d likes", [self.likeNum.text intValue] + 1];
    
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.objid.text block:^(PFObject *news, NSError *error) {
        NSMutableArray *arr = [news objectForKey:@"likedby"];
        [arr addObject:[UserData getUsername]];
        NSNumber *showlikenum = [news objectForKey:@"showlikenum"];
        
        news[@"likedby"] = arr;
        news[@"showlikenum"] = [NSNumber numberWithInteger:[showlikenum integerValue] + 1];
        [news saveInBackground];
    }];
}
@end
