//
//  Time.h
//  samsungHealth
//
//  Created by Hao Ge on 8/4/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Time : NSObject


@property (nonatomic) NSDate *today;
@property (nonatomic) NSDate *yesterday;
@property (nonatomic) NSDate *thisWeek;
@property (nonatomic) NSDate *lastWeek;
@property (nonatomic) NSDate *thisMonth;
@property (nonatomic) NSDate *lastMonth;

@end
