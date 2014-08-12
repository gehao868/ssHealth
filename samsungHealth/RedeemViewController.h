//
//  RedeemViewController.h
//  samsungHealth
//
//  Created by Sylvia Fang on 8/5/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reward.h"

@interface RedeemViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *couponDiscount;

@property (strong, nonatomic) IBOutlet UILabel *couponTitle;
@property (strong, nonatomic) IBOutlet UIImageView *coupontImg;
@property (strong, nonatomic) IBOutlet UITextView *couponDetail;
@property (strong, nonatomic) IBOutlet UILabel *expireDate;

@property (strong, nonatomic) Reward *reward;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
