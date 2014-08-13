//
//  SendGiftViewController.h
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendGiftViewController : UIViewController

- (IBAction)submit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *giftTitle;

@end
