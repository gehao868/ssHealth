//
//  CouponListViewController.m
//  samsungHealth
//
//  Created by Jessica Zhuang on 8/11/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "CouponListViewController.h"
#import "Reward.h"
#import <Parse/Parse.h>
#import "CouponDetailCell.h"
#import "RedeemViewController.h"
#import "UserData.h"
#import "Util.h"

@interface CouponListViewController ()

@end

@implementation CouponListViewController {
    NSMutableArray *rewards;
    NSMutableDictionary *dic;
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
    [Util formatTable:self.table];
    rewards = [[NSMutableArray alloc] init];
    dic = [[NSMutableDictionary alloc] init];
    self.table.hidden = YES;
    [self getCouponList];
    // Do any additional setup after loading the view.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
     refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(yo:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([reward.type isEqualToString:@"gift"]) {
        cell.expireDate.text = @"--";
    }
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [DEFAULT_COLOR_THEME];
    cell.selectedBackgroundView = myBackView;
    return cell;
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CouponDetailCell* cell = (CouponDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
//
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"RedeemDetail"])
    {
        NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
        CouponDetailCell *cell =(CouponDetailCell *)[self.table cellForRowAtIndexPath:indexPath];
        RedeemViewController *view = segue.destinationViewController;
        view.reward = [[Reward alloc] init];
        view.reward = [dic objectForKey:cell.couponName.text];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    //    [label setFont:[UIFont boldSystemFontOfSize:12]];
    //    NSString *string =[list objectAtIndex:section];
    //    /* Section header is in 0th index... */
    
    CGRect frame = CGRectMake(0, 0, 210, 32);
    UILabel *title  = [[UILabel alloc] initWithFrame:frame];
    [title setText:@" Coupon Title"];
    title.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:title];
    
    frame = CGRectMake(250, 0, 150, 32);
    UILabel *date = [[UILabel alloc] initWithFrame:frame];
    [date setText:@"Expire Date"];
    date.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:date];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

- (void) getCouponList {
    PFQuery *query = [PFQuery queryWithClassName:@"Reward"];
    [query whereKey:@"tousername" equalTo:[UserData getUsername]];
    [query whereKey:@"isredeemed" equalTo:@YES];
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        rewards = [[NSMutableArray alloc] init];
        dic = [[NSMutableDictionary alloc] init];
        for (PFObject *object in objects) {
            __block Reward *reward = [[Reward alloc] init];
            reward.fromusername = [object objectForKey:@"fromusername"];
            reward.tousername = [object objectForKey:@"tousername"];
            reward.expiredate = [object objectForKey:@"expiredate"];
            reward.pic = [object objectForKey:@"pic"];
            reward.title = [object objectForKey:@"title"];
            reward.detail = [object objectForKey:@"detail"];
            reward.discount = [object objectForKey:@"discount"];
            reward.type = [object objectForKey:@"type"];
            [rewards addObject:reward];
            [dic setObject:reward forKey:reward.title];
        }
        [self.table reloadData];
        self.table.hidden = NO;
    }];
}

- (void)yo:(UIRefreshControl *)refreshControl {
    [self getCouponList];
    [refreshControl endRefreshing];
}

@end
