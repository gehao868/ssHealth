//
//  DEMOSecondViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "TargetViewController.h"
#import "TargetViewDetailController.h"
#import "GoalTableCell.h"
#import "UserData.h"
#import <Parse/Parse.h>

@interface TargetViewController ()

@end

@implementation TargetViewController {
    NSMutableArray *finished;
    NSMutableArray *expected;
    NSDate *yesterday;
    NSDate *today;
    
    CGRect progressFrame;
    CGRect numberFrame;
    CGRect imgFrame;
    UIFont *font;
    
    NSMutableArray *imgList;
    
    NSArray* healthObjects;
    NSArray* goalObjects;
    NSDate *theDate;
}

@synthesize back;
@synthesize forward;
@synthesize calendar;

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
    self.goalTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    font = [UIFont systemFontOfSize:20.0f];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    today = [NSDate date];//This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    
    yesterday = [cal dateByAddingComponents:components toDate: today options:0];

    
    numberFrame = CGRectMake(20.0f, 5.0f, 120.0f, 20.0f);
    progressFrame = CGRectMake(20.0f, 5.0f + font.lineHeight + 2.0f, 110.0f, 20.0f);
    imgFrame = CGRectMake(0.0f, 2.0f, 44.0f, 44.0f);
    
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    //[self.datepicker fillDatesFromCurrentDate:14];
    //    [self.datepicker fillCurrentWeek];
    [self.datepicker fillCurrentMonth];
    //[self.datepicker fillCurrentYear];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d"];
    NSInteger day = [[dateFormat stringFromDate:[NSDate date]] intValue];
    
    [self.datepicker selectDateAtIndex:day-1];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.goalTable addSubview:refreshControl];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSelectedDate
{

    NSDate *date = self.datepicker.selectedDate;
    if ( date == nil) {
        date = yesterday;
    }
    theDate = date;
    [self getTime:date];
}

-(void) getTime: (NSDate*) date {
    NSLog(@"date is %@",date);
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"name" equalTo:[UserData getUsername]];
    
    [query whereKey:@"date" greaterThanOrEqualTo:date];
    
    [query whereKey:@"date" lessThanOrEqualTo:[date dateByAddingTimeInterval:60*60*24*1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        goalObjects = objects;
        [self getHealthData:date];
    }];
    
//    NSArray* healthObjects = [queryHealth findObjects];
    
//    NSArray* objects = [query findObjects];
    
}

- (void) getHealthData: (NSDate*) date {
    
    finished = [[NSMutableArray alloc] init];
    expected = [[NSMutableArray alloc] init];
    imgList =[[NSMutableArray alloc] init];
    

    PFQuery *queryHealth = [PFQuery queryWithClassName:@"HealthData"];
    [queryHealth whereKey:@"username" equalTo:[UserData getUsername]];
    
    
    [queryHealth whereKey:@"date" greaterThanOrEqualTo:date];
    [queryHealth whereKey:@"date" lessThanOrEqualTo:[date dateByAddingTimeInterval:60*60*24*1]];
    
    [queryHealth findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        healthObjects                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 = objects;
    }];
    
    if ([healthObjects count] == 0) {
        for (PFObject *object in goalObjects) {
            [expected addObject:[object objectForKey:@"expected"]];
            
            [imgList addObject:[object objectForKey:@"type"]];
            
            [finished addObject:[NSNumber numberWithInt:0]];
        }
    } else {
        for (PFObject *object in goalObjects) {
            [expected addObject:[object objectForKey:@"expected"]];
            
            [imgList addObject:[object objectForKey:@"type"]];
            
            [finished addObject:[healthObjects[0] objectForKey:[object objectForKey:@"type"]]];
            
        }
    }
    
    [self.goalTable reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [expected count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GoalTableCell";
    GoalTableCell *cell = (GoalTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GoalTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSNumber *x = (NSNumber*)[finished objectAtIndex:indexPath.row];
    NSNumber *y = (NSNumber*)[expected objectAtIndex:indexPath.row];
    
    
    NSString *text = [NSString stringWithFormat:@"%d%@%d", [x intValue], @"/",[y intValue]];
    cell.number.text = text;
    [cell.number setFont:font];
    
    cell.progress.progress =x.doubleValue / y.doubleValue;
    cell.progress.progressTintColor = [UIColor redColor];
    
    NSLog(@"image is %@",[imgList objectAtIndex:indexPath.row] );
    
    cell.image.image = [UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];
    cell.image.frame = CGRectMake(cell.image.frame.origin.x, cell.image.frame.origin.y, 44, 44);
    

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showCalendar"]) {
        NSIndexPath *indexPath = [self.goalTable indexPathForSelectedRow];
        TargetViewDetailController *destViewController = segue.destinationViewController;
        destViewController.type = [imgList objectAtIndex:indexPath.row];
    }
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self getTime:theDate];
    [refreshControl endRefreshing];
}


- (IBAction)showMenu
{
    [self.frostedViewController presentMenuViewController];
}



@end
