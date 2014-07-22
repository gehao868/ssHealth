//
//  FitbitViewController.m
//  Health360
//
//  Created by Trey_L on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <Parse/Parse.h>
#import "FitbitViewController.h"

@interface FitbitViewController ()

@end

static NSString * const fitbitUserInfo = @"fitbitUserInfo";
//static NSString * userid = NULL;
static NSString * username = NULL;

@implementation FitbitViewController

@synthesize fitbitFullName;
@synthesize fitbitSteps;

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
            username = [object objectForKey:@"username"];
        } else {
            NSLog(@"The currUser request failed.");
        }
    }];
    
    query = [PFQuery queryWithClassName:fitbitUserInfo];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            if (object == NULL) {
                NSLog(@"Error: no such user.");
            } else {
                fitbitFullName.text = [object objectForKey:@"fitbitFullName"];
                fitbitSteps.text = [object objectForKey:@"fitbitSteps"];
                NSLog(@"success!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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

@end
