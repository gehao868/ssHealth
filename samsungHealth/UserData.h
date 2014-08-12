//
//  UserData.h
//  samsungHealth
//
//  Created by Trey_L on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+ (NSString *)getUsername;
+ (void)setUsername:(NSString *) newUsername;

+ (NSData *)getAvatar;
+ (void)setAvatar:(NSData *) newAvatar;

+ (NSDate *)getBirthday;
+ (void)setBirthday:(NSDate *) newBirthday;

+ (NSString *)getGender;
+ (void)setGender:(NSString *) newGender;

+ (NSNumber *)getHeight;
+ (void)setHeight:(NSNumber *) newHeight;

+ (NSNumber *)getPoint;
+ (void)setPoint:(NSNumber *) newPoint;

+ (NSArray *)getAppFriends;
+ (void)setAppFriends:(NSArray *) newAppFriends;

+ (NSMutableDictionary *)getAppFriendAvatars;
+ (void)setAppFriendAvatars:(NSString *)url forKey:(NSString *)key;

+ (NSArray *)getRewards;
+ (void)setRewards:(NSArray *) newRewards;

+ (NSArray *)getGroups;
+ (void)setGroups:(NSArray *) newGroups;

+ (NSString *)getCurrgroup;
+ (void)setCurrgroup:(NSString *) newCurrgroup;

+ (NSArray *)getCurrgroupusers;
+ (void)setCurrgroupusers:(NSArray *) newCurrgroupusers;

+ (NSString *)getStateFileName;

@end
