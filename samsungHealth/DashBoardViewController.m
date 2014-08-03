//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DashBoardViewController.h"
#import "HealthData.h"
#import "DashTableViewCell.h"


@interface DashBoardViewController ()

@end

@implementation DashBoardViewController {
    NSArray *finished;
    NSArray *expected;
    NSArray *tableData;
    NSArray *thumbnails;
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"HealthData"];
    [query whereKey:@"UserID" equalTo:@1];

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
    
    [query whereKey:@"Time" lessThanOrEqualTo:today];
    [query whereKey:@"Time" greaterThan:yesterday];
    
    NSArray* objects = [query findObjects];
    for (PFObject *object in objects) {
         NSLog(@"%@", [object objectForKey:@"step"]);
         int heartrate = [[object objectForKey:@"heartrate"] intValue];
         int sleep = [[object objectForKey:@"sleep"] intValue];
         int step = [[object objectForKey:@"step"] intValue];
         int cups = [[object objectForKey:@"cups"] intValue];
         int losedWeight = [[object objectForKey:@"weight"] intValue];
         
         finished = [NSArray arrayWithObjects:[NSNumber numberWithInt:heartrate],[NSNumber numberWithInt:sleep],[NSNumber numberWithInt:step],[NSNumber numberWithInt:cups],[NSNumber numberWithInt:losedWeight], nil];
     }
   
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:160.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    
    self.largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(67.0f, 110.0f, 180.0f, 180.0f)];
    [self.view addSubview: self.largestProgressView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];

    thumbnails = [NSArray arrayWithObjects:@"heart_green", @"sleep_green", @"steps", @"water_green", @"weight_green",nil];
    
    expected = [NSArray arrayWithObjects: [NSNumber numberWithInt:80], [NSNumber numberWithInt:8], [NSNumber numberWithInt:1200], [NSNumber numberWithInt:6],[NSNumber numberWithInt:20],nil];

    
}

- (void)progressChange
{
    _largestProgressView.progress += 0.003;
    
    if (_largestProgressView.progress > 1.0f)
    {
        _largestProgressView.progress = 0.0f;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [thumbnails count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HealthDataCell";
    
    DashTableViewCell *cell = (DashTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HealthDataCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSNumber *x = (NSNumber*)[finished objectAtIndex:indexPath.row];
    NSNumber *y = (NSNumber*)[expected objectAtIndex:indexPath.row];
    float z = x.floatValue /y.floatValue;
    
    NSString *text = [[NSString alloc] initWithFormat:@"%2.0f %%",(z*100)];
    
    cell.output.text = text;


    cell.progress.progress =  x.doubleValue /y.doubleValue;
    cell.progress.progressTintColor = [UIColor redColor];
    
    cell.healthIconImage.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    
    return cell;
}



@end

