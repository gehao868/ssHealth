//
//  NewPostViewController.m
//  samsungHealth
//
//  Created by Trey_L on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "NewPostViewController.h"
#import "NewsFeedViewController.h"

#import "UserData.h"
#import <Parse/Parse.h>

@interface NewPostViewController ()

@end

@implementation NewPostViewController

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

- (IBAction)send:(id)sender {
    PFObject *post = [PFObject objectWithClassName:@"News"];
    post[@"content"] = self.postText.text;
    post[@"postusername"] = [UserData getUsername];
    post[@"likenum"] = @0;
    post[@"showlikenum"] = @0;
    post[@"groupname"] = [UserData getCurrgroup];
    [post saveInBackground];
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Post Sent" message:@"Succeed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
