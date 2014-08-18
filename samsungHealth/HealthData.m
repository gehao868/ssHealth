//
//  HealthData.m
//  samsungHealth
//
//  Created by Hao Ge on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "HealthData.h"

static NSNumber *heartrate;
static NSNumber *step;
static NSNumber *sleepLength;
static NSNumber *cups;
static NSNumber *bmi;
static NSNumber *fatratio;

@implementation HealthData

+ (NSNumber *)getStep {
    return step;
}
+ (void)setStep:(NSNumber *) newStep {
    step = newStep;
}

+ (NSNumber *)getCups{
    return cups;
}
+ (void)setCups:(NSNumber *) newCups{
    cups = newCups;
}

+ (NSNumber *)getSleep{
    return sleepLength;
}
+ (void)setSleep:(NSNumber *) newSleep{
    sleepLength = newSleep;
}

+ (NSNumber *)getBMI{
    return bmi;
}
+ (void)setBMI:(NSNumber *) newBMI{
    bmi = newBMI;
}

+ (NSNumber *)getHeartrate{
    return heartrate;
}
+ (void)setHeartrate:(NSNumber *) newHeartrate{
    heartrate = newHeartrate;
}

+ (NSNumber *)getFatratio{
    return fatratio;
}
+ (void)setFatratio:(NSNumber *) newFatratio{
    fatratio = newFatratio;
}


@end
