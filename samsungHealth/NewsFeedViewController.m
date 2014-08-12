//
//  NewsFeedViewController.m
//  samsungHealth
//
//  Created by Trey_L on 8/8/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "UserData.h"
#import "ConnectViewController.h"
#import "NewsFeedViewController.h"

#import <Parse/Parse.h>

@interface NewsFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@end

int currIndex = 1;
UITableView *postTableView;
NSMutableDictionary *groups;
NSMutableArray *groupnames;
SINavigationMenuView *menu;

@implementation NewsFeedViewController

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
    
    if (self.navigationItem) {
        groups = [[NSMutableDictionary alloc] init];
        groupnames = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(addView:error:)];
    }
}

- (void)addView:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        
        [groupnames addObject:@"Manage Group"];
        for (PFObject *object in objects) {
            NSString *groupname = [object objectForKey:@"name"];
            [groupnames addObject:groupname];
            NSArray *users = [object objectForKey:@"users"];
            [groups setObject:users forKey:groupname];
        }
        
        CGRect frame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        menu = [[SINavigationMenuView alloc] initWithFrame:frame];
        [menu displayMenuInView:self.navigationController.view];
        menu.items = groupnames;
        [menu setTitle:[menu.items objectAtIndex:currIndex]];
        menu.delegate = self;
        self.navigationItem.titleView = menu;
        
        postTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        postTableView.frame = CGRectMake(0, 165, self.view.frame.size.width, self.view.frame.size.height-165);
        postTableView.delegate = self;
        postTableView.dataSource = self;
        [self.view addSubview:postTableView];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [groups objectForKey:[groupnames objectAtIndex:currIndex]];
    return dict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSArray *array = [groups objectForKey:[menu.items objectAtIndex:currIndex]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    if (index == 0) {
        ConnectViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"connectController"];
        [self.navigationController pushViewController:next animated:YES];
    } else {
        currIndex = index;
        [menu setTitle:[menu.items objectAtIndex:currIndex]];
        [UserData setCurrgroup:[menu.items objectAtIndex:currIndex]];
        self.navigationItem.titleView = menu;
        [postTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu
{
    [self.frostedViewController presentMenuViewController];
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
