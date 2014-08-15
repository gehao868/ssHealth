
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
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

NSString *isLoggedin;
NSUserDefaults *defaults;

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
        [UserData setAppFriendAvatars:[UserData getAvatar] forKey:[UserData getUsername]];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query whereKey:@"username" equalTo:[UserData getUsername]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                [UserData setPoint:[object objectForKey:@"point"]];
                [UserData setAppFriends:[object objectForKey:@"appfriends"]];
                
                for (NSString *name in [object objectForKey:@"appfriends"]) {
                PFQuery *query = [PFQuery queryWithClassName:@"Users"];
                    [query whereKey:@"username" equalTo:name];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
                        [UserData setAppFriendAvatars:[user objectForKey:@"avatar"] forKey:name];
                    }];
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
    CGPoint newCneter = CGPointMake(self.loginBtn.center.x, self.loginBtn.center.y - 140.0f);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    self.loginBtn.center = newCneter;
    [self.coverView setAlpha:1];
    [UIView commitAnimations];
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
             //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             //[appDelegate sessionStateChanged:session state:state error:error];
             [self sessionStateChanged:session state:state error:error];
         }];
    }
    
    [self.view setHidden:YES];
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
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                // For simplicity, here we just show a generic message for all other errors
                // To handle other errors using: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
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
        NSString *tmpusername = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"first_name"], [user objectForKey:@"last_name"]];
        
        [UserData setUsername:tmpusername];
        [UserData setBirthday:[user objectForKey:@"birthday"]];
        [UserData setGender:[user objectForKey:@"gender"]];
        
        [defaults setObject:[UserData getUsername] forKey:@"username"];
        [defaults setObject:[UserData getBirthday] forKey:@"birthday"];
        [defaults setObject:[UserData getGender] forKey:@"gender"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query whereKey:@"username" equalTo:[defaults objectForKey:@"username"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    [UserData setHeight:[object objectForKey:@"height"]];
                    [UserData setPoint:[object objectForKey:@"point"]];
                    
                    [defaults setObject:[UserData getHeight] forKey:@"height"];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Users"];
        [query1 whereKey:@"username" equalTo:[UserData getUsername]];
        [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                [UserData setPoint:[object objectForKey:@"point"]];
                [UserData setAppFriends:[object objectForKey:@"appfriends"]];
                
                for (NSString *name in [object objectForKey:@"appfriends"]) {
                    PFQuery *query2 = [PFQuery queryWithClassName:@"Users"];
                    [query2 whereKey:@"username" equalTo:name];
                    [query2 getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
                        [UserData setAppFriendAvatars:[user objectForKey:@"avatar"] forKey:name];
                    }];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        [self performSegueWithIdentifier:@"skipLogin" sender:nil];
    }];
    
    /*
     [FBRequestConnection startWithGraphPath:@"/me/friends" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
     NSArray *friends = [result objectForKey:@"data"];
     //NSLog(@"%@", friends);
     [UserData setAppFriends:friends];
     
     [defaults setObject:[UserData getAppFriends] forKey:@"appFriends"];
     }];
     */
    
    NSMutableDictionary *picturePara = [[NSMutableDictionary alloc] init];
    [picturePara setValue:@"false" forKey:@"redirect"];
    [picturePara setValue:@"large" forKey:@"type"];
    [picturePara setValue:@"500" forKey:@"height"];
    [picturePara setValue:@"500" forKey:@"width"];
    [FBRequestConnection startWithGraphPath:@"/me/picture" parameters:picturePara HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
        NSString *url = [[result objectForKey:@"data"] objectForKey:@"url"];
        //NSLog(@"%@", url);
        
        [UserData setAvatar:url];
        [defaults setObject:[UserData getAvatar] forKey:@"avatar"];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query whereKey:@"username" equalTo:[UserData getUsername]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            user[@"avatar"] = url;
            [user saveInBackground];
        }];
    }];
}

@end
