//
//  DashTableViewCell.h
//  samsungHealth
//
//  Created by Hao Ge on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *output;
@property (weak, nonatomic) IBOutlet UIImageView *healthIconImage;
@property (weak, nonatomic) IBOutlet UIView *progress;

@end
