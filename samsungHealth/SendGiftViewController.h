//
//  SendGiftViewController.h
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendGiftViewController : UIViewController <UITextViewDelegate>

- (IBAction)submit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *giftTitle;
- (IBAction)exit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *giftDetail;
@property (strong, nonatomic) IBOutlet UIButton *selectFriend;
@property (strong, nonatomic) IBOutlet UILabel *friendName;
- (IBAction)select:(id)sender;

@property (strong, nonatomic) NSString *name;

@end
