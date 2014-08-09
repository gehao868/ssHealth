//
//  UserData.m
//  samsungHealth
//
//  Created by Trey_L on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "UserData.h"

static NSString *username;
static NSDate *birthday;
static NSString *gender;
static NSNumber *height;
static NSData *avatar;
static NSArray *appFriends;
static NSString *stateFileName = @"stateFile";

@implementation UserData

+ (NSString *)getUserID {
    return userID;
}
+ (void)setUserID:(NSString *) newUserID {
    userID = newUserID;
}

+ (NSString *)getBirthday {
    return birthday;
}
+ (void)setBirthday:(NSString *) newBirthday {
    birthday = newBirthday;
}

+ (NSString *)getFirstName {
    return firstName;
}
+ (void)setFirstName:(NSString *) newFirstName {
    firstName = newFirstName;
}

+ (NSString *)getLastName {
    return lastName;
}
+ (void)setLastName:(NSString *) newLastName {
    lastName = newLastName;
}

+ (NSString *)getEmail {
    return email;
}
+ (void)setEmail:(NSString *) newEmail {
    email = newEmail;
}

+ (NSString *)getGender {
    return gender;
}
+ (void)setGender:(NSString *) newGender {
    gender = newGender;
}

+ (NSData *)getAvatar {
    return avatar;
}
+ (void)setAvatar:(NSData *) newAvatar {
    avatar = newAvatar;
}

+ (NSArray *)getAppFriends {
    return appFriends;
}
+ (void)setAppFriends:(NSArray *) newAppFriends {
    appFriends = newAppFriends;
}

+ (NSArray *)getFBFriends {
    return FBFriends;
}
+ (void)setFBFriends:(NSArray *) newFBFriends {
    FBFriends = newFBFriends;
}

+ (NSString *)getStateFileName {
    return stateFileName;
}

@end