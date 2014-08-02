//
//  UserData.h
//  samsungHealth
//
//  Created by Trey_L on 8/1/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+ (NSString *)getUserID;
+ (void)setUserID:(NSString *) newUserID;

+ (NSString *)getBirthday;
+ (void)setBirthday:(NSString *) newBirthday;

+ (NSString *)getFirstName;
+ (void)setFirstName:(NSString *) newFirstName;

+ (NSString *)getLastName;
+ (void)setLastName:(NSString *) newLastName;

+ (NSString *)getEmail;
+ (void)setEmail:(NSString *) newEmail;

+ (NSString *)getGender;
+ (void)setGender:(NSString *) newGender;

+ (NSData *)getAvatar;
+ (void)setAvatar:(NSData *) newAvatar;

@end
