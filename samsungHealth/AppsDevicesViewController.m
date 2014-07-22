//
//  AppsDevicesViewController.m
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <Parse/Parse.h>
#import <OAuthiOS/OAuthiOS.h>
#import "AppsDevicesViewController.h"

@interface AppsDevicesViewController ()

@end

static NSString * const OAuthKeyForFitbit = @"s0ROr_j8tXMhlAfwlPQ4SXKQWQM";
static NSString * const fitbitUserInfo = @"fitbitUserInfo";
static NSString * userid = NULL;
static NSString * username = NULL;

@implementation AppsDevicesViewController

@synthesize fibitbutton;

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
    // Do any additional setup after loading the view.
    PFQuery *query = [PFQuery queryWithClassName:@"currUser"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            userid = object.objectId;
            username = [object objectForKey:@"username"];
        } else {
            NSLog(@"The currUser request failed.");
        }
    }];
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

- (IBAction)fibitAction:(id)sender {
    // fetch data from Parse
    PFQuery *query = [PFQuery queryWithClassName:fitbitUserInfo];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if (object == NULL) {
                OAuthIOModal *oauthioModal =
                [[OAuthIOModal alloc] initWithKey:OAuthKeyForFitbit delegate:self];
                [oauthioModal showWithProvider:@"fitbit"];
            } else {
                OAuthIORequest * request = [object objectForKey:@"requestToken"];
                [self requestFromFitbit:request];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    //call cloud function
    //    [PFCloud callFunctionInBackground:@"hello"
    //                       withParameters:@{}
    //                                block:^(NSString *result, NSError *error) {
    //                                    if (!error) {
    //                                        self.stepLabel.text = result;
    //                                    }
    //                                }];
}

- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request {
    //NSDictionary *credentials = [request getCredentials];
    //NSLog(@"get Token: %@", credentials[@"oauth_token"]);
    //NSLog(@"get Secret: %@", credentials[@"oauth_token_secret"]);
    
    // push request token to Parse
    PFObject *userInfo = [PFObject objectWithClassName:fitbitUserInfo];
    userInfo[@"username"] = username;
    userInfo[@"requestToken"] = request;
    [userInfo saveInBackground];

    [self requestFromFitbit:request];
}

- (void)didFailWithOAuthIOError:(NSError *)error {
    // ignore
    NSLog(@"error: %@", error.description);
}

- (void)requestFromFitbit:(OAuthIORequest *)request {
    [self getUserInfo:request];
    [self getSteps:request];
}

- (void)getUserInfo:(OAuthIORequest *)request {
    
    [request get:@"https://api.fitbit.com/1/user/-/profile.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         //NSLog(@"status code:%i\n\n", httpResponse.statusCode);
         NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         id fitbitFullName = [json valueForKeyPath:@"user.fullName"];
         NSLog(@"%@", fitbitFullName);
         
         // update fitbitFullName
         PFQuery *query = [PFQuery queryWithClassName:fitbitUserInfo];
         [query getObjectInBackgroundWithId:userid block:^(PFObject *object, NSError *error) {
             object[@"fitbitFullName"] = fitbitFullName;
             [object saveInBackground];
             
         }];
     }];
}

- (void)getSteps:(OAuthIORequest *)request {
    
    [request get:@"https://api.fitbit.com/1/user/-/activities/date/today.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         //NSLog(@"status code:%i\n\n", httpResponse.statusCode);
         NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSString* fitbitSteps = [[json valueForKeyPath:@"summary.steps"] stringValue];
         NSLog(@"%@", fitbitSteps);
         
         // update fitbitSteps
         PFQuery *query = [PFQuery queryWithClassName:fitbitUserInfo];
         [query getObjectInBackgroundWithId:userid block:^(PFObject *object, NSError *error) {
             object[@"fitbitSteps"] = fitbitSteps;
             [object saveInBackground];
             
         }];
     }];
}

@end
