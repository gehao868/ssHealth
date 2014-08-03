//
//  GoalTableCell.h
//  samsungHealth
//
//  Created by Quincy on 7/30/14.
//  Copyright (c) 2014 Quincy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *number;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
