//
//  HealthData.h
//  samsungHealth
//
//  Created by Hao Ge on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthData : NSObject

+(NSInteger*) getSteps;
+(void) setSteps: (NSInteger *)s;
+(NSInteger *) getHeartrate;
+(void) setHeartrate: (NSInteger*)h;
+(double) getWeight;
+(void) setWeight:(double)w;
+(NSInteger *) getCups;
+(void) setCups: (NSInteger*)cups;


@end
