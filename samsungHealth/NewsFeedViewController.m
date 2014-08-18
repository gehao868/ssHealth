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
#import "HealthTime.h"
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
    
    [self fetchProgress];
    
    myTableDelegate = [[TableDelegate alloc] init];
    [self.table setDelegate:myTableDelegate];
    [self.table setDataSource:myTableDelegate];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];

    if (self.navigationItem) {
        groups = [[NSMutableDictionary alloc] init];
        groupnames = [[NSMutableArray alloc] init];
        news = [[NSMutableArray alloc] init];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Group"];
        [query findObjectsInBackgroundWithTarget:self selector:@selector(addView:error:)];
    }
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGRect frame = CGRectMake(screenSize.width - 62.0, screenSize.height - 62, 56.0, 56.0);
    self.buttonView.frame = frame;
    [self.view bringSubviewToFront:self.buttonView];
}

- (void)viewWillAppear:(BOOL)animated {
    moreIsHidden = YES;
    [self.moreView setHidden:moreIsHidden];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self adjustHeightOfTableview];
}

- (void) fetchProgress {
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"date" greaterThanOrEqualTo:[HealthTime getToday]];
    [query whereKey:@"date" lessThanOrEqualTo:[[HealthTime getToday] dateByAddingTimeInterval:60*60*24*1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *goals, NSError *error) {
        NSInteger totle = 0;
        NSInteger done = 0;
        for (PFObject *goal in goals) {
            NSString *name = [goal objectForKey:@"name"];
            NSString *isDone = [goal objectForKey:@"done"];
            
            totle++;
            [Global addTotleGoal:name number:1];
            if ([isDone isEqualToString:@"yes"]) {
                done++;
                [Global addDoneGoal:name number:1];
            } else {
                // ignore
            }
        }
        
        double rate = (totle == 0) ? 0 : 1.0*done/totle;
        NSString *text = [[NSString alloc] initWithFormat:@"%2.0f%%", rate*100];
        [self.progressLabel setText:text];
        
        DACircularProgressView *tmpView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(20.0f, 75.0f, 80.0f, 80.0f)];
        [tmpView setProgress:rate];
        [self.view addSubview:tmpView];
    }];
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
       
        [self.view bringSubviewToFront:self.buttonView];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
}

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
            news.likedby = [object objectForKey:@"likedby"];
            news.likenum = [NSNumber numberWithInteger:news.likedby.count];
            news.postusername = [object objectForKey:@"postusername"];
            news.showlikenum = [object objectForKey:@"showlikenum"];
            news.type = [object objectForKey:@"type"];
            news.objecid = object.objectId;
            PFFile *file = [object objectForKey:@"media"];
            news.media = [file getData];
            [array addObject:news];
        }
        [Global setNewsFeed:array];
        self.table.backgroundColor = [DEFAULT_COLOR_DARKCYAN];
        [self.table reloadData];
        [self adjustHeightOfTableview];
    }];
}

- (void)adjustHeightOfTableview
{
    CGFloat height = self.table.contentSize.height;
    CGFloat maxHeight = self.table.superview.frame.size.height - self.table.frame.origin.y;
    
    // if the height of the content is greater than the maxHeight of
    // total space on the screen, limit the height to the size of the
    // superview.
    
    if (height > maxHeight)
        height = maxHeight;
    
    // now set the frame accordingly
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.table.frame;
        frame.size.height = height;
        self.table.frame = frame;
        
        // if you have other controls that should be resized/moved to accommodate
        // the resized tableview, do that here, too
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
     - (IBAction)playAudio:(id)sender {
     }
@end
