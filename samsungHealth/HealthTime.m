//
//  Time.m
//  samsungHealth
//
//  Created by Hao Ge on 8/4/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "HealthTime.h"

static NSDate *today;
static NSDate *tomorrow;


@implementation HealthTime

+ (NSDate *)getToday{
    return today;
}
+ (void)setToday:(NSDate *) newToday{
    today = newToday;
}

+ (NSDate *)getTomorrow{
    return tomorrow;
}

+ (void)setTomorrow:(NSDate *) newTomorrow {
    tomorrow = newTomorrow;
}


@end
