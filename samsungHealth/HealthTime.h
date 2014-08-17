//
//  Time.h
//  samsungHealth
//
//  Created by Hao Ge on 8/4/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthTime : NSObject

+ (NSDate *)getToday;
+ (void)setToday:(NSDate *) newToday;

+ (NSDate *)getTomorrow;
+ (void)setTomorrow:(NSDate *) newTomorrow;

@end
