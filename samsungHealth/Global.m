//
//  Global.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "Global.h"

static NSString *toUserName;
static NSString *currGroup;
static BOOL isToUserName;
static NSMutableArray *newsFeed;
static NSInteger showlikenum;
static NSMutableDictionary *totelGoal;
static NSMutableDictionary *doneGoal;

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

+ (NSInteger) getTotelGoal:(NSString *)name {
    if (totelGoal == NULL || [totelGoal objectForKey:name] == nil) {
        return 0;
    }
    return [[totelGoal objectForKey:name] integerValue];
}
+ (void) addTotleGoal:(NSString *)name number:(NSInteger) num {
    if (totelGoal == NULL) {
        totelGoal = [[NSMutableDictionary alloc] init];
    }
    if ([totelGoal objectForKey:name] == nil) {
        [totelGoal setValue:[NSString stringWithFormat:@"%ld", num] forKey:name];
    } else {
        NSInteger newNum = [[totelGoal objectForKey:name] integerValue] + num;
        [totelGoal setValue:[NSString stringWithFormat:@"%ld", newNum] forKey:name];
    }
}
+ (void) clearTotleGoal {
    totelGoal = [[NSMutableDictionary alloc] init];
}

+ (NSInteger) getDoneGoal:(NSString *)name {
    if (doneGoal == NULL || [doneGoal objectForKey:name] == nil) {
        return 0;
    }
    return [[doneGoal objectForKey:name] integerValue];
}
+ (void) addDoneGoal:(NSString *)name number:(NSInteger) num {
    if (doneGoal == NULL) {
        doneGoal = [[NSMutableDictionary alloc] init];
    }
    if ([doneGoal objectForKey:name] == nil) {
        [doneGoal setValue:[NSString stringWithFormat:@"%ld", num] forKey:name];
    } else {
        NSInteger newNum = [[doneGoal objectForKey:name] integerValue] + num;
        [doneGoal setValue:[NSString stringWithFormat:@"%ld", newNum] forKey:name];
    }
}
+ (void) clearDoneGoal {
    doneGoal = [[NSMutableDictionary alloc] init];
}

@end
