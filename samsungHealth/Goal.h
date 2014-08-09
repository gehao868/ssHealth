//
//  Goal.h
//  samsungHealth
//
//  Created by Hao Ge on 8/8/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goal : NSObject

@property (nonatomic) NSNumber *type;
@property (nonatomic) NSNumber *expected;
@property (nonatomic) NSNumber *current;
@property (nonatomic) NSString *des;

@end
