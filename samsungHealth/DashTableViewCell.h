//
//  DashTableViewCell.h
//  samsungHealth
//
//  Created by Hao Ge on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *output;
@property (strong, nonatomic) IBOutlet UIImageView *healthIconImage;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;

@end
