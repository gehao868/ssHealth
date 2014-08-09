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

@property (nonatomic) NSInteger *calories;
@property (nonatomic) NSInteger *cups;
@property (nonatomic) double *fatratio;
@property (nonatomic) NSInteger *heartrate;
@property (nonatomic) NSInteger *height;
@property (nonatomic) NSInteger *sleep;
@property (nonatomic) NSInteger *stepcount;
@property double weight;


@end
