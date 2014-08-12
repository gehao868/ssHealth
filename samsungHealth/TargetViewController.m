//
//  DEMOSecondViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "TargetViewController.h"
#import "GoalTableCell.h"
#import "UserData.h"
#import <Parse/Parse.h>

@interface TargetViewController ()

@end

@implementation TargetViewController {
    NSMutableArray *finished;
    NSMutableArray *expected;
    CGRect progressFrame;
    CGRect numberFrame;
    CGRect imgFrame;
    UIFont *font;
    NSMutableArray *imgList;
    
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
    
    [calendar setBackgroundImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [calendar setTitle:@"" forState:UIControlStateNormal];
    [forward setBackgroundImage:[UIImage imageNamed:@"forward_grey"] forState:UIControlStateNormal];
    [forward setTitle:@"" forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"back_grey"] forState:UIControlStateNormal];
    [back setTitle:@"" forState:UIControlStateNormal];
    
    
    
    font = [UIFont systemFontOfSize:20.0f];
    
    imgList = [NSMutableArray arrayWithObjects:@"steps", @"food_green", @"sleep_green", nil];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"name" equalTo:[UserData getUsername]];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [NSDate date];//This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    
    
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    
    [query whereKey:@"date" greaterThan:yesterday];
    
    finished = [[NSMutableArray alloc] init];
    expected = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    
    PFQuery *queryHealth = [PFQuery queryWithClassName:@"HealthData"];
    [queryHealth whereKey:@"username" equalTo:[UserData getUsername]];
    [query whereKey:@"date" greaterThan:yesterday];
    
    NSArray* healthObjects = [queryHealth findObjects];

    
    int heartrate = [[healthObjects[0] objectForKey:@"heartrate"] intValue];
    int sleep = [[healthObjects[0] objectForKey:@"sleep"] intValue];
    int step = [[healthObjects[0] objectForKey:@"step"] intValue];
    int cups = [[healthObjects[0] objectForKey:@"cups"] intValue];
    int losedWeight = [[object objectForKey:@"weight"] intValue];
    
    //[mutableDict setValue:[] forKeyPath:<#(NSString *)#>]

    
    NSArray* objects = [query findObjects];
    
    
    for (PFObject *object in objects) {
        [expected addObject:[object objectForKey:@"expected"]];
        
    }
    
    numberFrame = CGRectMake(20.0f, 5.0f, 120.0f, 20.0f);
    progressFrame = CGRectMake(20.0f, 5.0f + font.lineHeight + 2.0f, 120.0f, 20.0f);
    imgFrame = CGRectMake(0.0f, 2.0f, 60.0f, 20.0f);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    
    cell.image.image = [UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];
    cell.image.frame = CGRectMake(cell.image.frame.origin.x, cell.image.frame.origin.x, 50, 50);
    return cell;
}

- (IBAction)showMenu
{
    [self.frostedViewController presentMenuViewController];
}



@end
