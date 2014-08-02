//
//  HealthData.m
//  samsungHealth
//
//  Created by Hao Ge on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "HealthData.h"

static NSInteger *steps;
static NSInteger *heartrate;
static double weight;
static NSInteger *cupsOfwater;

@implementation HealthData {

}

+(NSInteger*) getSteps {
    return steps;
}

+(void) setSteps: (NSInteger *)s{
    steps = s;
}

+(NSInteger *) getHeartrate {
    return heartrate;
}

+(void) setHeartrate: (NSInteger*)h{
    heartrate = h;
}

+(double) getWeight{
    return weight;
}
+(void) setWeight:(double)w{
    weight = w;
}

+(NSInteger *) getCups {
    return cupsOfwater;
}

+(void) setCups: (NSInteger*)cups{
    cupsOfwater = cups;
}


@end
