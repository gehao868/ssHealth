//
//  RewardViewController.m
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "RewardViewController.h"
#import "UserData.h"
#import <Parse/Parse.h>
#import "Reward.h"
#import "CouponDetailCell.h"
#import "RedeemViewController.h"
#import "RedeemViewController.h"

@interface RewardViewController ()

@end

@implementation RewardViewController{
    float random;
    float startValue;
    float endValue;
    NSDictionary *awards;
    NSArray *miss;
    NSArray *data;
    NSString *result;
    int pointNeeded;
    __block Reward *reward;
    BOOL isRewarding;
    int count;
}


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
    srand((unsigned)time(0));
    reward = [[Reward alloc] init];
    isRewarding = NO;
    count = 0;
    
    pointNeeded = 300;
    self.user.text = [UserData getUsername];
    self.userIcon.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[UserData getAvatar]]]];
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 30.0;
    self.userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userIcon.layer.borderWidth = 3.0f;
    self.userIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.userIcon.layer.shouldRasterize = YES;
    self.userIcon.clipsToBounds = YES;
    
    self.rewardPoint.text = [[UserData getPoint] stringValue];
    
    data = @[@"1st prize",@"2nd prize",@"3rd prize",@"gift",@"try again"];
    //中奖和没中奖之间的分隔线设有2个弧度的盲区，指针不会旋转到的，避免抽奖的时候起争议。
    /*miss = @[
             @{@"min": @47,
               @"max":@89
               },
             @{@"min": @90,
               @"max":@133
               },
             @{@"min": @182,
               @"max":@223
               },
             @{@"min": @272,
               @"max":@314
               },
             @{@"min": @315,
               @"max":@358
               }
             ];
    
    
    awards = @{
               @"1st prize": @[
                       @{
                           @"min": @137,
                           @"max":@178
                           }
                       ],
               @"2nd prize": @[
                       @{
                           @"min": @227,
                           @"max":@268
                           }
                       ],
               @"3rd prize": @[
                       @{
                           @"min": @2,
                           @"max":@43
                           }
                       ],
               @"try again":miss
               };*/
    miss = @[
             @{@"min": @292,
               @"max":@315
               },
             @{@"min": @343,
               @"max":@359
               },
             @{@"min": @25,
               @"max":@50
               },
             @{@"min": @87,
               @"max":@114
               },
             @{@"min": @151,
               @"max":@188
               },
             @{@"min": @207,
               @"max":@259
               }
             ];
    
    
    awards = @{
               @"1st prize": @[
                       @{
                           @"min": @260,
                           @"max":@276
                           }
                       ],
               @"2nd prize": @[
                       @{
                           @"min": @325,
                           @"max":@342
                           },
                       @{
                           @"min": @51,
                           @"max":@68
                           }
                       ],
               @"3rd prize": @[
                       @{
                           @"min": @18,
                           @"max":@35
                           },
                       @{
                           @"min": @133,
                           @"max":@150
                           },
                       @{
                           @"min": @189,
                           @"max":@206
                           }
                       ],
               @"gift": @[
                       @{
                           @"min": @277,
                           @"max":@291
                           },
                       @{
                           @"min": @0,
                           @"max":@17
                           },
                       @{
                           @"min": @69,
                           @"max":@86
                           },
                       @{
                           @"min": @115,
                           @"max":@132
                           }
                       ],
               @"try again":miss
               };
    // Do any additional setup after loading the view.
}

- (IBAction)start:(id)sender {
    if (isRewarding) {
        return;
    }
    
    isRewarding = YES;
    if ([[UserData getPoint] intValue] < pointNeeded) {
        NSString *text = @"You at lease than ";
        text = [text stringByAppendingString:[[NSNumber numberWithInt:pointNeeded] stringValue]];
        text = [text stringByAppendingString:@" to play!"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Woops"
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];

    } else {
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        endValue = [self fetchResult];
        rotationAnimation.delegate = self;
        rotationAnimation.fromValue = @(startValue);
        rotationAnimation.toValue = @(endValue);
        rotationAnimation.duration = 2.0f;
        rotationAnimation.autoreverses = NO;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeBoth;
        [_rotateStaticImageView.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];
    
        [self deducePoint];
        self.rewardPoint.text = [@([[UserData getPoint] intValue] - pointNeeded) stringValue];
        [UserData setPoint:@([[UserData getPoint] intValue] - pointNeeded)];
    }
}

-(float)fetchResult{
    
    //todo: fetch result from remote service
    
    random = rand() %4;
    int i = random;
    if (count <= 3) {
        result = data[3-count];
    } else {
        result = data[i];
    }  //TEST DATA ,shoud fetch result from remote service
//    if (_labelTextField.text != nil && ![_labelTextField.text isEqualToString:@""]) {
//        result = _labelTextField.text;
//    }
    count++;
    for (NSString *str in [awards allKeys]) {
        if ([str isEqualToString:result]) {
            NSDictionary *content = awards[str][0];
            int min = [content[@"min"] intValue];
            int max = [content[@"max"] intValue];
            
            
            srand((unsigned)time(0));
            random = rand() % (max - min) +min;
            
            return radians(random + 360*5);
        }
    }
    
    random = rand() %5;
    i = random;
    NSDictionary *content = miss[i];
    int min = [content[@"min"] intValue];
    int max = [content[@"max"] intValue];
    
    srand((unsigned)time(0));
    random = rand() % (max - min) +min;
    
    return radians(random + 360*5);
    
}

//角度转弧度
double radians(float degrees) {
    return degrees*M_PI/180;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    startValue = endValue;
    if (startValue >= endValue) {
        startValue = startValue - radians(360*10);
    }
    
    NSLog(@"startValue = %f",startValue);
    NSLog(@"result = %@",result);
    NSLog(@"endValue = %f\n",endValue);
    if (![result  isEqual: @"try again"]) {
        [[[UIAlertView alloc] initWithTitle:@"Congratulations!" message:[@"You win " stringByAppendingString:result] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Detail", nil] show];
        [self getCouponDetail];
        
    } else {
        _label1.text = result;
    }
    
    isRewarding = NO;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is : %li",(long)buttonIndex);
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        RedeemViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"RedeemCoupon"];
        next.reward = [[Reward alloc] init];
        next.reward.type = result;
        [self.navigationController pushViewController:next animated:YES];
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

- (void) getCouponDetail {
    PFQuery *query = [PFQuery queryWithClassName:@"Reward"];
    [query whereKey:@"type" equalTo:result];
    [query whereKey:@"isredeemed" equalTo:@NO];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            reward.fromusername = [object objectForKey:@"fromusername"];
            reward.tousername = [object objectForKey:@"tousername"];
            reward.pic = [object objectForKey:@"pic"];
            reward.type = [object objectForKey:@"type"];
            reward.isredeemed = YES;
            reward.expiredate = [object objectForKey:@"expiredate"];
            reward.detail = [object objectForKey:@"detail"];
            reward.title = [object objectForKey:@"title"];
            reward.discount = [object objectForKey:@"discount"];
            
            NSLog(@"%@", reward.expiredate);
            [self saveCoupon];
        }
    }];
    
}

- (void) saveCoupon {
    PFObject *object = [PFObject objectWithClassName:@"Reward"];
    object[@"fromusername"] = reward.fromusername;
    object[@"tousername"] = [UserData getUsername];
    object[@"pic"] = reward.pic;
    object[@"type"] = reward.type;
    object[@"isredeemed"] = @YES;
    
    if (reward.expiredate != NULL) {
        object[@"expiredate"] = reward.expiredate;
    }
    object[@"detail"] = reward.detail;
    object[@"title"] = reward.title;
    object[@"discount"] = reward.discount;
    [object saveInBackground];
}

- (void) deducePoint {
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"username" equalTo:[UserData getUsername]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        object[@"point"] = [UserData getPoint];
        [object saveInBackground];
    }];
}

- (IBAction)play:(UIButton *)sender {
}

- (IBAction)showMenu:(id)sender {
        [self.frostedViewController presentMenuViewController];
}


// --------------shaking---------------
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        //NSLog(@"shaking.........");
        [self start:nil];
    }
}

@end
