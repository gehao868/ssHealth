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
#import "HealthTime.h"
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
    
    NSMutableArray* healthObjects;
    NSMutableArray* goalObjects;
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
    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDateComponents *newComponents = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [newComponents setHour:-[newComponents hour]];
    [newComponents setMinute:-[newComponents minute]];
    [newComponents setSecond:-[newComponents second]];
    today = [NSDate date];//This variable should now be pointing at a date object that is the start of today (midnight);
    
    [newComponents setHour:-24];
    [newComponents setMinute:0];
    [newComponents setSecond:0];
    
    yesterday = [cal dateByAddingComponents:newComponents toDate: today options:0];
    
    
    
    //****
    
    
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    //[components setHour:-4];
    
    
    NSCalendar *newCal =[NSCalendar currentCalendar];
   // [newCal setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    today = [newCal dateFromComponents:components];
    theDate = today;
    
    NSLog(@"today is %@", today);
    
    numberFrame = CGRectMake(20.0f, 5.0f, 120.0f, 20.0f);
    progressFrame = CGRectMake(20.0f, 5.0f + font.lineHeight + 2.0f, 110.0f, 20.0f);
    imgFrame = CGRectMake(0.0f, 2.0f, 44.0f, 44.0f);
    
    [self.datepicker fillCurrentMonth];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   // [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormat setDateFormat:@"d"];
    NSInteger day = [[dateFormat stringFromDate:yesterday] intValue];
    
    [self.datepicker selectDateAtIndex:day];
    
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    self.goalTable.hidden = YES;
    
    //[self.datepicker fillDatesFromCurrentDate:14];
    //    [self.datepicker fillCurrentWeek];
    //[self.datepicker fillCurrentYear];
    
    [self getTime:today];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
     refreshControl.tintColor = [UIColor whiteColor];
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
   
    if (date == nil) {
        date = today;
    }
    theDate = date;
    [self getTime:date];
}

-(void) getTime: (NSDate*) date {
    PFQuery *queryHealth = [PFQuery queryWithClassName:@"HealthData"];
    [queryHealth whereKey:@"username" equalTo:[UserData getUsername]];

    NSLog(@"The date is %@", date);
    
    [queryHealth whereKey:@"date" greaterThanOrEqualTo:[date dateByAddingTimeInterval:-60*60*4*1]];
    [queryHealth whereKey:@"date" lessThanOrEqualTo:[date dateByAddingTimeInterval:60*60*20*1]];
    [queryHealth findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        healthObjects = [[NSMutableArray alloc] init];
        for (PFObject *object in objects) {
            [healthObjects addObject:object];
        }
        [self getHealthData:date];
//        NSLog(@"health object count is %lu", (unsigned long)[healthObjects count]);
        
    }];
    

}

- (void) getHealthData: (NSDate*) date {
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    NSDate *newDate = [date ];
    
    NSLog(@"enter 0******");

    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"name" equalTo:[UserData getUsername]];
    
    [query whereKey:@"date" greaterThanOrEqualTo:date];
    [query whereKey:@"date" lessThanOrEqualTo:[date dateByAddingTimeInterval:60*60*20*1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        finished = [[NSMutableArray alloc] init];
        expected = [[NSMutableArray alloc] init];
        imgList =[[NSMutableArray alloc] init];
        goalObjects = [[NSMutableArray alloc] init];
        for (PFObject *object in objects) {
            [goalObjects addObject:object];
        }
        if ([healthObjects count] == 0) {
            NSLog(@"count is 0******");
            for (PFObject *object in goalObjects) {
                
                [expected addObject:[object objectForKey:@"expected"]];
                
                [imgList addObject:[object objectForKey:@"type"]];
                
                [finished addObject:[NSNumber numberWithInt:0]];
            }
            
            NSLog(@"finsih 0******");


        } else {
            
             NSLog(@"count is 1******");
            
            
            int i = [healthObjects count] - 1;
            for (PFObject *object in goalObjects) {
                NSLog(@"goal object count is %lu", (unsigned long)[goalObjects count]);

                [expected addObject:[object objectForKey:@"expected"]];
                
                [imgList addObject:[object objectForKey:@"type"]];
                if ([[object objectForKey:@"type"] isEqualToString:@"fatraito" ]|| [[object objectForKey:@"type"] isEqualToString:@"weight"]||[[object objectForKey:@"type"] isEqualToString:@"heartrate"]) {
                    [finished addObject:[healthObjects[i] objectForKey:@"active"]];
                } else if ([[object objectForKey:@"type"] isEqualToString:@"sleep" ]){
                    NSNumber *asleep = [NSNumber numberWithDouble:[[healthObjects[i] objectForKey:@"asleep"] doubleValue] / 60.0];
                    
                    [finished addObject:asleep];
                } else{
                    [finished addObject:[healthObjects[i] objectForKey:[object objectForKey:@"type"]]];
                }
                
            }
        }
        
        [self.goalTable reloadData];
        self.goalTable.hidden = NO;
    }];
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
    
    NSString *unit =  [NSString new];
    NSString *type = [[goalObjects objectAtIndex:indexPath.row] objectForKey:@"type"];
    if ([type isEqualToString:@"cups"]) {
        unit = @"cups";
    } else if ([type isEqualToString:@"step"]){
        unit = @"steps";
    } else if ([type isEqualToString:@"sleep"]){
        unit = @"hours";
    } else {
        unit = @"minutes";
    }
    
    NSString *text = [NSString stringWithFormat:@"%d%@%d %@", [x intValue], @"/",[y intValue], unit];
    cell.number.text = text;
    [cell.number setFont:font];
    
    cell.progress.progress =x.doubleValue / y.doubleValue;
    cell.progress.progressTintColor = [DEFAULT_COLOR_GREEN];
    if (cell.progress.progress < 0.60) {
        cell.progress.progressTintColor = [DEFAULT_COLOR_RED];
    } else if (cell.progress.progress < 0.80) {
        cell.progress.progressTintColor = [DEFAULT_COLOR_YELLOW];
    }
    
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

-(BOOL)loadViewWithClassName:(NSString*)name title:(NSString*)title {
    
    Class controllerClass=NSClassFromString(name);
    
    if(controllerClass){
        UIViewController* backController=[[controllerClass alloc]initWithNibName:@"CUSLayerVC" bundle:nil];
        backController.title = title;
        [self.navigationController pushViewController:backController animated:YES];
        return YES;
    }
    
    return NO;
}


@end
