//
//  Goal.h
//  samsungHealth
//
//  Created by Hao Ge on 8/8/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Goal : NSObject

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *type;
@property (nonatomic) NSNumber *expected;
@property (nonatomic) NSDate *date;

@end
