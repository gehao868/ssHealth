//
//  DetailViewController.h
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) NSString *healthDataName;
@property (strong, nonatomic) NSNumber *dataValue;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *val;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendGoal;
@property (weak, nonatomic) IBOutlet UIImageView *goalTypePic;

@end
