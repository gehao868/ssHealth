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
    NSMutableArray *rewards;
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
    rewards = [[NSMutableArray alloc] init];
    self.table.hidden = YES;
    [self getCouponList];
    self.userIcon.image = [UIImage imageWithData:[UserData getAvatar]];
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 30.0;
    self.userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userIcon.layer.borderWidth = 3.0f;
    self.userIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.userIcon.layer.shouldRasterize = YES;
    self.userIcon.clipsToBounds = YES;
    
    data = @[@"1st prize",@"2nd prize",@"3rd prize",@"try again"];
    //中奖和没中奖之间的分隔线设有2个弧度的盲区，指针不会旋转到的，避免抽奖的时候起争议。
    miss = @[
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
               };
    // Do any additional setup after loading the view.
}
- (IBAction)start:(id)sender {
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
}

-(float)fetchResult{
    
    //todo: fetch result from remote service
    srand((unsigned)time(0));
    random = rand() %4;
    int i = random;
    result = data[i];  //TEST DATA ,shoud fetch result from remote service
//    if (_labelTextField.text != nil && ![_labelTextField.text isEqualToString:@""]) {
//        result = _labelTextField.text;
//    }
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
    } else {
        _label1.text = result;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is : %li",(long)buttonIndex);
    switch (buttonIndex) {
        case 0:{
            
        }break;
        default:
            break;
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

- (IBAction)play:(UIButton *)sender {
}

- (IBAction)showMenu:(id)sender {
        [self.frostedViewController presentMenuViewController];
}

- (IBAction)segmentControl:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.userIcon.hidden = NO;
            self.rewardPoint.hidden = NO;
            self.label1.hidden = NO;
            self.plateImageView.hidden = NO;
            self.rotateStaticImageView.hidden = NO;
            self.user.hidden = NO;
            self.playBtn.hidden = NO;
            self.points.hidden = NO;
            self.startBtn.hidden = NO;
            self.table.hidden = YES;
            break;
        case 1:
            self.userIcon.hidden = YES;
            self.rewardPoint.hidden = YES;
            self.label1.hidden = YES;
            self.plateImageView.hidden = YES;
            self.rotateStaticImageView.hidden = YES;
            self.user.hidden = YES;
            self.playBtn.hidden = YES;
            self.points.hidden = YES;
            self.startBtn.hidden = YES;
            self.table.hidden = NO;
            break;
        default:
            break;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rewards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"CouponDetailCell";
    CouponDetailCell *cell = (CouponDetailCell *)[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CouponDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Reward *reward = (Reward *)[rewards objectAtIndex:indexPath.row];
    cell.couponName.text = reward.title;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *date = [dateFormatter stringFromDate:reward.expiredate];
    cell.expireDate.text = date;
    return cell;
    
}

- (void) getCouponList {
    PFQuery *query = [PFQuery queryWithClassName:@"Reward"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            __block Reward *reward = [[Reward alloc] init];
            reward.fromusername = [object objectForKey:@"fromuername"];
            reward.tousername = [object objectForKey:@"tousername"];
            reward.expiredate = [object objectForKey:@"expiredate"];
            reward.pic = [object objectForKey:@"pic"];
            reward.title = [object objectForKey:@"title"];
            reward.detail = [object objectForKey:@"detail"];
            reward.discount = [object objectForKey:@"discount"];
            
            if (reward.tousername && !([reward.tousername isEqualToString:[UserData getUsername]])) {
                continue;
            }
            [rewards addObject:reward];
        }
        [self.table reloadData];
    }];
}

@end
