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

@property (nonatomic) NSString *username;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSNumber *calories;
@property (nonatomic) NSNumber *step;
@property (nonatomic) NSNumber *cups;
@property (nonatomic) NSNumber *heartrate;
@property (nonatomic) NSNumber *sleep;
@property (nonatomic) NSNumber *asleep;
@property (nonatomic) NSNumber *active;
@property (nonatomic) NSNumber *weight;
@property (nonatomic) NSNumber *fatratio;

@end
