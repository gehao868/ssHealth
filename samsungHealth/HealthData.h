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

@property (nonatomic) NSNumber *calories;
@property (nonatomic) NSNumber *cups;
@property (nonatomic) NSNumber *fatratio;
@property (nonatomic) NSNumber *heartrate;
@property (nonatomic) NSNumber *height;
@property (nonatomic) NSNumber *sleep;
@property (nonatomic) NSNumber *stepcount;
@property NSNumber *weight;


@end
