//
//  RewardRedeemControllerViewController.m
//  samsungHealth
//
//  Created by Sylvia Fang on 8/5/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "RewardRedeemController.h"
#import "RedeemCouponCell.h"

@interface RewardRedeemController ()

@end

@implementation RewardRedeemController{
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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"GoalTableCell";
//    GoalTableCell *cell = (GoalTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoalTableCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    NSNumber *x = (NSNumber*)[finished objectAtIndex:indexPath.row];
//    NSNumber *y = (NSNumber*)[expected objectAtIndex:indexPath.row];
//    
//    NSString *text = [NSString stringWithFormat:@"%d%@%d", [x intValue], @"/",[y intValue]];
//    cell.number.text = text;
//    [cell.number setFont:font];
//    
//    cell.progress.progress =x.doubleValue / y.doubleValue;
//    cell.progress.progressTintColor = [UIColor redColor];
//    
//    cell.image.image = [UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];
//    cell.image.frame = CGRectMake(cell.image.frame.origin.x, cell.image.frame.origin.x, 50, 50);
//    return cell;
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

@end
