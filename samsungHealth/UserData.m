//
//  UserData.m
//  samsungHealth
//
//  Created by Trey_L on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "UserData.h"

static NSString *username;
static NSData *avatar;
static NSDate *birthday;
static NSString *gender;
static NSNumber *height;
static NSNumber *point;
static NSArray *appFriends;
static NSMutableDictionary *appFriendAvatars;
static NSArray *rewards;
static NSArray *groups;
static NSString *stateFileName = @"stateFile";

@implementation UserData

+ (NSString *)getUsername {
    return username;
}
+ (void)setUsername:(NSString *) newUsername {
    username = newUsername;
}

+ (NSData *)getAvatar {
    return avatar;
}
+ (void)setAvatar:(NSData *) newAvatar {
    avatar = newAvatar;
}

+ (NSDate *)getBirthday {
    return birthday;
}
+ (void)setBirthday:(NSDate *) newBirthday {
    birthday = newBirthday;
}

+ (NSString *)getGender {
    return gender;
}
+ (void)setGender:(NSString *) newGender {
    gender = newGender;
}

+ (NSNumber *)getHeight {
    return height;
}
+ (void)setHeight:(NSNumber *) newHeight {
    height = newHeight;
}

+ (NSNumber *)getPoint {
    return point;
}
+ (void)setPoint:(NSNumber *) newPoint {
    point = newPoint;
}

+ (NSArray *)getAppFriends {
    return appFriends;
}
+ (void)setAppFriends:(NSArray *) newAppFriends {
    appFriends = newAppFriends;
}

+ (NSMutableDictionary *)getAppFriendAvatars {
    return appFriendAvatars;
}
+ (void)setAppFriendAvatars:(NSString *)url forKey:(NSString *)key {
    if (appFriendAvatars == NULL) {
        appFriendAvatars = [[NSMutableDictionary alloc] init];
    }
    [appFriendAvatars setObject:url forKey:key];
}

+ (NSArray *)getRewards {
    return rewards;
}
+ (void)setRewards:(NSArray *) newRewards {
    rewards = newRewards;
}

+ (NSArray *)getGroups {
    return groups;
}
+ (void)setGroups:(NSArray *) newGroups {
    groups = newGroups;
}

+ (NSString *)getStateFileName {
    return stateFileName;
}

@end