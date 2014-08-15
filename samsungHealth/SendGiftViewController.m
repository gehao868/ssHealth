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
#import "Global.h"
#import "Util.h"

@interface SendGiftViewController () <UITextViewDelegate>

@end

@implementation SendGiftViewController

@synthesize giftDetail;
@synthesize giftTitle;
@synthesize selectFriend;
@synthesize friendName;

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
    self.navigationItem.title = @"Send Gift";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    giftDetail.layer.borderWidth = 5.0f;
    giftDetail.layer.borderColor = [[UIColor grayColor] CGColor];
    if ([Global getToUserSet])
        friendName.text = [Global getToUserName];
    
    friendName.hidden = YES;
    [Util formatTextField:giftTitle];
    [[giftDetail layer] setBorderColor:[[DEFAULT_COLOR_GREEN CGColor]];
    [[giftDetail layer] setBorderWidth:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard {
    [giftDetail endEditing:YES];
    [giftDetail resignFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated {
    if ([Global getToUserSet]) {
        friendName.text = [Global getToUserName];
        friendName.hidden = NO;
        selectFriend.enabled = NO;
        selectFriend.hidden = YES;
        [Global setToUserSet:NO];
    }
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
    object[@"tousername"] = [Global getToUserName];
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

}
@end
