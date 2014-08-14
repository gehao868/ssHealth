//
//  Global.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "Global.h"

static NSString * toUserName;

@implementation Global

+ (NSString*) getToUserName {
    return toUserName;
}

+ (void) setToUserName:(NSString *)newToUserName {
    toUserName = newToUserName;
}

@end
