//
//  CouponListViewController.h
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/11/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *table;

@end
