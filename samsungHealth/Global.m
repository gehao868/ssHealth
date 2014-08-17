//
//  Global.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "Global.h"

static NSString * toUserName;
static NSString * currGroup;
static BOOL isToUserName;
static NSMutableArray *newsFeed;
static NSInteger showlikenum;

@implementation Global

+ (NSString*) getToUserName {
    return toUserName;
}
+ (void) setToUserName:(NSString *)newToUserName {
    toUserName = newToUserName;
}

+(NSString *) getCurrGroup {
    return currGroup;
}
+(void) setCurrGroup:(NSString *) newCurrGroup {
    currGroup = newCurrGroup;
}

+ (BOOL) getToUserSet {
    if (isToUserName)
        return isToUserName;
    return false;
}

+ (void) setToUserSet:(BOOL)set {
    isToUserName = set;
}

+ (NSMutableArray *) getNewsFeed {
    return  newsFeed;
}

+ (void) setNewsFeed:(NSMutableArray *)array {
    newsFeed = array;
}

+ (NSInteger) getShowlikenum {
    return showlikenum;
}
+ (void) setShowlikenum: (NSInteger) newShowlikenum {
    showlikenum = newShowlikenum;
}

@end
