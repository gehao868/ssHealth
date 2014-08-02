//
//  AppDelegate.m
//  samsungHealth
//
//  Created by Hao Ge on 7/22/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "AppDelegate.h"

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserData.h"

NSUserDefaults *defaults;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"kStw7vZqIGXaQdnwjyBX2p4XMuKuwZ6cBVuOKPbW"
                  clientKey:@"mrKuZDmmDbA3zo0yT3KIYifozNFXhfUBsntMel6T"];
    
    [FBLoginView class];
    [FBProfilePictureView class];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // To handle other errors using: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Confirm logout message
    //[self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:@"true" forKey:@"isLoggedin"];
    
    /* make the API call */
    [FBRequestConnection startWithGraphPath:@"/me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary* user, NSError *error) {
        //NSLog(@"%@", user);
        [UserData setUserID:[user objectForKey:@"id"]];
        [UserData setBirthday:[user objectForKey:@"birthday"]];
        [UserData setFirstName:[user objectForKey:@"first_name"]];
        [UserData setLastName:[user objectForKey:@"last_name"]];
        [UserData setEmail:[user objectForKey:@"email"]];
        [UserData setGender:[user objectForKey:@"gender"]];
        
        [defaults setObject:[UserData getUserID] forKey:@"id"];
        [defaults setObject:[UserData getBirthday] forKey:@"birthday"];
        [defaults setObject:[UserData getFirstName] forKey:@"first_name"];
        [defaults setObject:[UserData getLastName] forKey:@"last_name"];
        [defaults setObject:[UserData getEmail] forKey:@"email"];
        [defaults setObject:[UserData getGender] forKey:@"gender"];
    }];
    
    [FBRequestConnection startWithGraphPath:@"/me/friends" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        NSArray *friends = [result objectForKey:@"data"];
        //NSLog(@"%@", friends);
        [UserData setAppFriends:friends];
        
        [defaults setObject:[UserData getAppFriends] forKey:@"appFriends"];
    }];
    
    NSMutableDictionary *picturePara = [[NSMutableDictionary alloc] init];
    [picturePara setValue:@"false" forKey:@"redirect"];
    [picturePara setValue:@"large" forKey:@"type"];
    [picturePara setValue:@"500" forKey:@"height"];
    [picturePara setValue:@"500" forKey:@"width"];
    [FBRequestConnection startWithGraphPath:@"/me/picture" parameters:picturePara HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        NSString *url = [[result objectForKey:@"data"] objectForKey:@"url"];
        //NSLog(@"%@", url);
        [UserData setAvatar:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        
        [defaults setObject:[UserData getAvatar] forKey:@"avatar"];
    }];
    
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends" parameters:picturePara HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        NSArray *friends = [result objectForKey:@"data"];
        NSLog(@"%@", friends);
        
        NSSortDescriptor *descriptor =
        [[NSSortDescriptor alloc] initWithKey:last
                                    ascending:NO
                                     selector:@selector(localizedCaseInsensitiveCompare:)];
        NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, lastDescriptor, nil];
        sortedArray = [array sortedArrayUsingDescriptors:descriptors];
        
        NSMutableArray *FBFriends = [[NSMutableArray alloc] init];

        for (NSDictionary *dict in friends) {
            NSMutableDictionary *elm = [[NSMutableDictionary alloc] init];
            [elm setValue:[dict objectForKey:@"name"] forKey:@"name"];
            [elm setValue:[[dict objectForKey:@"data"] objectForKey:@"url"] forKey:@"pic"];
            [FBFriends set:];
            [FBFriendsPic addObject:];
        }
        
        [UserData setAvatar:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    }];
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end
