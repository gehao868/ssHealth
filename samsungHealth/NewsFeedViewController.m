//
//  NewsFeedViewController.m
//  samsungHealth
//
//  Created by Trey_L on 8/8/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "UserData.h"
#import "Global.h"
#import "ConnectViewController.h"
#import "NewsFeedViewController.h"
#import "TableDelegate.h"
#import <Parse/Parse.h>
#import "News.h"
#import "NewsFeedCell.h"

@interface NewsFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@end

int currIndex = 0;
BOOL moreIsHidden = YES;
UITableView *postTableView;
NSMutableDictionary *groups;
NSMutableArray *groupnames;
NSMutableArray *news;
SINavigationMenuView *menu;
UIRefreshControl *currRC;

@implementation NewsFeedViewController
{
    NSMutableArray *userPicArray;
    NSMutableArray *userNameArray;
}
@synthesize myTableDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        TableDelegate *delegate = [[TableDelegate alloc] init];
//        self.table.delegate = delegate;
//        self.table.dataSource = delegate;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    myTableDelegate = [[TableDelegate alloc] init];
    [self.table setDelegate:myTableDelegate];
    [self.table setDataSource:myTableDelegate];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];

    if (self.navigationItem) {
        groups = [[NSMutableDictionary alloc] init];
        groupnames = [[NSMutableArray alloc] init];
        news = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(addView:error:)];
        
//        PFQuery *query1 = [PFQuery queryWithClassName:@"News"];
//        [query1 findObjectsInBackgroundWithTarget:self selector:@selector(getNews:error:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    moreIsHidden = YES;
    [self.moreView setHidden:moreIsHidden];
}

- (void)addView:(NSArray *)objects error:(NSError *)error {
    if (!error) {
        for (PFObject *object in objects) {
            NSString *groupname = [object objectForKey:@"name"];
            [groupnames addObject:groupname];
            NSArray *users = [object objectForKey:@"users"];
            [groups setObject:users forKey:groupname];
        }
        
        CGRect menuFrame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
        menu = [[SINavigationMenuView alloc] initWithFrame:menuFrame];
        [menu displayMenuInView:self.navigationController.view];
        menu.items = groupnames;
        [menu setTitle:[menu.items objectAtIndex:currIndex]];
        [Global setCurrGroup:[menu.items objectAtIndex:currIndex]];
        menu.delegate = self;
        self.navigationItem.titleView = menu;
        [self getNewsFeed:0];
        
//        postTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//        postTableView.frame = CGRectMake(0, 165, self.view.frame.size.width, self.view.frame.size.height-165);
//        postTableView.delegate = self;
//        postTableView.dataSource = self;
//        
//        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
//        [postTableView addSubview:refreshControl];
//        
//        [self.view addSubview:postTableView];
        
        [self.view bringSubviewToFront:self.buttonView];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}
//
//- (void)getNews:(NSArray *)objects error:(NSError *)error {
//    if (!error) {
//        for (PFObject *object in objects) {
//            [news addObject:object];
//        }
//    } else {
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//    }
//}
//
//- (void)refresh:(UIRefreshControl *)refreshControl {
//    groups = [[NSMutableDictionary alloc] init];
//    groupnames = [[NSMutableArray alloc] init];
//    news = [[NSMutableArray alloc] init];
//    currRC = refreshControl;
//    
//    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
//    [query findObjectsInBackgroundWithTarget:self selector:@selector(addViewRefresh:error:)];
//}
//
//- (void)addViewRefresh:(NSArray *)objects error:(NSError *)error {
//    if (!error) {
//        for (PFObject *object in objects) {
//            NSString *groupname = [object objectForKey:@"name"];
//            [groupnames addObject:groupname];
//            NSArray *users = [object objectForKey:@"users"];
//            [groups setObject:users forKey:groupname];
//        }
//        
//        CGRect menuFrame = CGRectMake(0.0, 0.0, 200.0, self.navigationController.navigationBar.bounds.size.height);
//        menu = [[SINavigationMenuView alloc] initWithFrame:menuFrame];
//        [menu displayMenuInView:self.navigationController.view];
//        menu.items = groupnames;
//        [menu setTitle:[menu.items objectAtIndex:currIndex]];
//        [Global setCurrGroup:[menu.items objectAtIndex:currIndex]];
//        menu.delegate = self;
//        self.navigationItem.titleView = menu;
//        
//        postTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//        postTableView.frame = CGRectMake(0, 165, self.view.frame.size.width, self.view.frame.size.height-165);
//        postTableView.delegate = self;
//        postTableView.dataSource = self;
//        
//        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
//        [postTableView addSubview:refreshControl];
//        
//        [self.view addSubview:postTableView];
//        
//        [self.view bringSubviewToFront:self.buttonView];
//        
//        PFQuery *query1 = [PFQuery queryWithClassName:@"News"];
//        [query1 findObjectsInBackgroundWithTarget:self selector:@selector(getNewsRefresh:error:)];
//    } else {
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//    }
//}
//
//- (void)getNewsRefresh:(NSArray *)objects error:(NSError *)error {
//    if (!error) {
//        for (PFObject *object in objects) {
//            [news addObject:object];
//        }
//    } else {
//        NSLog(@"Error: %@ %@", error, [error userInfo]);
//    }
//    
//    [postTableView reloadData];
//    [currRC endRefreshing];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    NSString *gname = [menu.items objectAtIndex:currIndex];
    for (PFObject *object in news) {
        NSString *currgname = [object objectForKey:@"groupname"];
        if ([gname isEqualToString:currgname]) {
            count++;
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CellId";
    
    NewsFeedCell *cell = (NewsFeedCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (nil == cell)
    {
        cell = [[NewsFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    int count = 0;
    NSString *gname = [menu.items objectAtIndex:currIndex];
    for (PFObject *object in news) {
        NSString *currgname = [object objectForKey:@"groupname"];
        if ([gname isEqualToString:currgname]) {
            if (count == indexPath.row) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"content"]];
                break;
            }
            count++;
        }
    }
    
    cell.userPic.image =[UIImage imageNamed:[userPicArray objectAtIndex:indexPath.row]];
    cell.userName.text = [userNameArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    currIndex = index;
    [menu setTitle:[menu.items objectAtIndex:currIndex]];
    [Global setCurrGroup:[menu.items objectAtIndex:currIndex]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"name" equalTo:[Global getCurrGroup]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *group, NSError *error) {
        if (!error) {
            [UserData setCurrgroupusers:[group objectForKey:@"users"]];
        } else {
            // ignore
        }
    }];
    
    NSLog(@"%d", index);
    [self getNewsFeed:index];
    self.navigationItem.titleView = menu;
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

- (void) getNewsFeed:(int) index {
    PFQuery *query = [PFQuery queryWithClassName:@"News"];
    [query whereKey:@"groupname" equalTo:[groupnames objectAtIndex:index]];
    [query orderByDescending:@"updatedAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        __block NSMutableArray *array = [[NSMutableArray alloc] init];
        for (PFObject *object in objects) {
            __block News *news = [[News alloc] init];
            news.groupname = [object objectForKey:@"groupname"];
            news.content = [object objectForKey:@"content"];
            news.likenum = [object objectForKey:@"likenum"];
            news.postusername = [object objectForKey:@"postusername"];
            news.showlikenum = [object objectForKey:@"showlikenum"];
            news.type = [object objectForKey:@"type"];
            [array addObject:news];
        }
        [Global setNewsFeed:array];
        [self.table reloadData];
    }];
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self getNewsFeed:currIndex];
    [refreshControl endRefreshing];
}

- (IBAction)more:(id)sender {
    moreIsHidden = !moreIsHidden;
    [self.moreView setHidden:moreIsHidden];
    [self.view bringSubviewToFront:self.moreView];
}

- (IBAction)managegroup:(id)sender {
    ConnectViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"connectController"];
    [self.navigationController pushViewController:next animated:YES];
    self.navigationItem.hidesBackButton = NO;
}

- (IBAction)sendgift:(id)sender {
    ConnectViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"SendGiftViewController"];
    [self.navigationController pushViewController:next animated:YES];
    self.navigationItem.hidesBackButton = NO;
}

- (IBAction)managefriend:(id)sender {
    // TODO
}
@end
