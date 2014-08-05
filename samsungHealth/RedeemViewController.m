//
//  RedeemViewController.m
//  samsungHealth
//
//  Created by Sylvia Fang on 8/5/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "RedeemViewController.h"
#import "RedeemCouponCell.h"

@interface RedeemViewController ()

@end

@implementation RedeemViewController {
    NSMutableArray *coupon;
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
    // Do any additional setup after loading the view.
    coupon = [NSMutableArray arrayWithObjects:@"Vitamin C", @"Message", @"Samsung Gear Fit 10% Off", @"Fitbit $10 Off", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RedeemCouponCell";
    RedeemCouponCell *cell = (RedeemCouponCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RedeemCouponCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSString *couponContent = [coupon objectAtIndex:indexPath.row];

    cell.text.text = couponContent;
    return cell;
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
