//
//  HealthData.h
//  samsungHealth
//
//  Created by Hao Ge on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface HealthData : NSObject

+ (NSNumber *)getStep;
+ (void)setStep:(NSNumber *) newStep;

+ (NSNumber *)getCups;
+ (void)setCups:(NSNumber *) newCups;

+ (NSNumber *)getSleep;
+ (void)setSleep:(NSNumber *) newSleep;

+ (NSNumber *)getBMI;
+ (void)setBMI:(NSNumber *) newBMI;

+ (NSNumber *)getHeartrate;
+ (void)setHeartrate:(NSNumber *) newHeartrate;

+ (NSNumber *)getFatratio;
+ (void)setFatratio:(NSNumber *) newFatratio;

+ (NSNumber *)getActive;
+ (void)setActive:(NSNumber *) newActive;

+ (NSNumber *)getAsleep;
+ (void)setAsleep:(NSNumber *) newAsleep;

@end
