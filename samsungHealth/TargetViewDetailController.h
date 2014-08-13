//
//  TargetViewDetailController.h
//  samsungHealth
//
//  Created by Hao Ge on 7/30/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "DACircularProgressView.h"
#import "CalendarView.h"


@interface TargetViewDetailController : UIViewController<CalendarDelegate>

@property (strong, nonatomic) DACircularProgressView *largestProgressView;


@end
