//
//  AppDelegate.h
//  samsungHealth
//
//  Created by Hao Ge on 7/22/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class AppDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *userID;
    NSString *birthday;
    NSString *firstName;
    NSString *lastName;
    NSString *email;
    NSString *gender;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *gender;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;
@end
