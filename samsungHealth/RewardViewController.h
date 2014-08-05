//
//  RewardViewController.h
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface RewardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *rewardPoint;
- (IBAction)play:(UIButton *)sender;

- (IBAction)showMenu:(id)sender;

@end
