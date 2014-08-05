//
//  RewardViewController.m
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "RewardViewController.h"
#import "UserData.h"

@interface RewardViewController ()

@end

@implementation RewardViewController


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
    self.userIcon.image = [UIImage imageWithData:[UserData getAvatar]];
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = 30.0;
    self.userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userIcon.layer.borderWidth = 3.0f;
    self.userIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.userIcon.layer.shouldRasterize = YES;
    self.userIcon.clipsToBounds = YES;
    
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

- (IBAction)play:(UIButton *)sender {
}

- (IBAction)showMenu:(id)sender {
        [self.frostedViewController presentMenuViewController];
}
@end
