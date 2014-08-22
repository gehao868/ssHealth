//
//  RedeemViewController.m
//  samsungHealth
//
//  Created by Sylvia Fang on 8/5/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "RedeemViewController.h"
#import <Parse/Parse.h>

@interface RedeemViewController ()

@end

@implementation RedeemViewController {
 
}

@synthesize couponDetail;
@synthesize couponDiscount;
@synthesize couponTitle;
@synthesize coupontImg;
@synthesize reward;
@synthesize expireDate;
@synthesize dateLabel;

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
    if (reward.title) {
        [self setContent];
    } else {
        couponDetail.hidden = YES;
        couponDiscount.hidden = YES;
        couponTitle.hidden = YES;
        coupontImg.hidden = YES;
        expireDate.hidden = YES;
        dateLabel.hidden = YES;
        [self getCouponDetail];
    }
    self.QRCode.image = [UIImage imageNamed:@"QRCode"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getCouponDetail {
    PFQuery *query = [PFQuery queryWithClassName:@"Reward"];
    [query whereKey:@"type" equalTo:reward.type];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            reward.fromusername = [object objectForKey:@"fromusername"];
            reward.tousername = [object objectForKey:@"tousername"];
            reward.expiredate = [object objectForKey:@"expiredate"];
            reward.pic = [object objectForKey:@"pic"];
            reward.title = [object objectForKey:@"title"];
            reward.detail = [object objectForKey:@"detail"];
            reward.discount = [object objectForKey:@"discount"];
            reward.type = [object objectForKey:@"type"];
         }
        [self setContent];
        couponDetail.hidden = NO;
        couponDiscount.hidden = NO;
        couponTitle.hidden = NO;
        coupontImg.hidden = NO;
        if ([reward.type isEqualToString:@"gift"]) {
            dateLabel.hidden = YES;
        } else {
            expireDate.hidden = NO;
            dateLabel.hidden = NO;
        }
        NSLog(@"%d", dateLabel.hidden);
    }];
   
}

- (void) setContent {
    if ([reward.type isEqualToString:@"gift"]) {
        couponDiscount.text = [@"From: " stringByAppendingString:reward.fromusername];
        dateLabel.hidden = YES;
        expireDate.hidden = YES;
        _QRCode.hidden = YES;
    } else {
        couponDiscount.text = reward.discount;
        _QRCode.hidden = NO;
    }
    couponDetail.text = reward.detail;
    couponTitle.text = reward.title;
    
    couponDiscount.backgroundColor = [UIColor darkGrayColor];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:reward.pic]];
    coupontImg.image = [UIImage imageWithData:data];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    expireDate.text = [dateFormatter stringFromDate:reward.expiredate];
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
