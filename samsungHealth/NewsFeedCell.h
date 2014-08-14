//
//  NewsFeedCell.h
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *newsContent;
@property (strong, nonatomic) IBOutlet UILabel *postUser;

@property (strong, nonatomic) IBOutlet UILabel *likeNum;

@end
