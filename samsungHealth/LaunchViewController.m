
//
//  LaunchViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 7/31/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "LaunchViewController.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "UserData.h"

#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

@interface LaunchViewController ()

@end

NSString *isLoggedin;

@implementation LaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    isLoggedin = [defaults objectForKey:@"isLoggedin"];
    
    if ([isLoggedin isEqual:@"true"]) {
        [self.view setHidden:YES];
        [UserData setUsername:[defaults objectForKey:@"username"]];
        [UserData setBirthday:[defaults objectForKey:@"birthday"]];
        [UserData setGender:[defaults objectForKey:@"gender"]];
        [UserData setAvatar:[defaults objectForKey:@"avatar"]];
        [UserData setHeight:[defaults objectForKey:@"height"]];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query whereKey:@"username" equalTo:[UserData getUsername]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    [UserData setPoint:[object objectForKey:@"point"]];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if ([isLoggedin isEqual:@"true"]) {
        [self performSegueWithIdentifier:@"skipLogin" sender:self];
    }
}

- (IBAction)FBLogin:(id)sender {
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] allowLoginUI:YES completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
