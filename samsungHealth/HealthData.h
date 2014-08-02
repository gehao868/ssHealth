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

@property (nonatomic) NSInteger *step; // name of recipe
@property (nonatomic) NSInteger *heartrate;
@property double weight;
@property (nonatomic) NSInteger *cups;

@end
