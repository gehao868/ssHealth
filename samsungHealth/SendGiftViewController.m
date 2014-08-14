//
//  SendGiftViewController.m
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "SendGiftViewController.h"
#import <Parse/Parse.h>
#import "UserData.h"
#import "FriendListViewController.h"

@interface SendGiftViewController () <UITextViewDelegate>

@end

@implementation SendGiftViewController

@synthesize giftDetail;
@synthesize giftTitle;
@synthesize selectFriend;
@synthesize friendName;
@synthesize name;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    giftDetail.layer.borderWidth = 5.0f;
    giftDetail.layer.borderColor = [[UIColor grayColor] CGColor];
//    name = @"adasd";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [giftDetail endEditing:YES];
    [giftDetail resignFirstResponder];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (IBAction)submit:(id)sender {
    PFObject *object = [PFObject objectWithClassName:@"Reward"];
    object[@"fromusername"] = [UserData getUsername];
    object[@"tousername"] = @"Quincy Yip";
    object[@"pic"] = [UserData getAvatar];
    object[@"type"] = @"gift";
    object[@"isredeemed"] = @NO;
    object[@"detail"] = giftDetail.text;
    object[@"title"] = giftTitle.text;
    object[@"discount"] = @"This is a gift";
    [object saveInBackground];

}
- (IBAction)exit:(id)sender {
//    UITextField *temp = (UITextField*)sender;
}

- (IBAction)select:(id)sender {
    // Create the root view controller for the navigation controller
    // The new view controller configures a Cancel and Done button for the
    // navigation bar.
//    FriendListViewController *controller = [[FriendListViewController alloc] init];
    
    // Configure the RecipeAddViewController. In this case, it reports any
    // changes to a custom delegate object.
    
    // Create the navigation controller and present it.
//    UINavigationController *navigationController = [[UINavigationController alloc]
//                                                    initWithRootViewController:controller];
//    [self presentViewController:controller animated:YES completion: nil];
    if (name) {
        NSLog(@"%@", name);
    } else {
        NSLog(@"%@", @"nothing");
    }
}
@end
