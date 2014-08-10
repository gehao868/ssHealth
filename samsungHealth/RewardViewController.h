//
//  RewardViewController.h
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface RewardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *rewardPoint;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIImageView *plateImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rotateStaticImageView;
- (IBAction)play:(UIButton *)sender;

- (IBAction)showMenu:(id)sender;
- (IBAction)segmentControl:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UILabel *user;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UILabel *points;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UITableView *table;


@end
