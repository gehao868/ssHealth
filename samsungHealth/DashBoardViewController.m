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
#import "DetailViewController.h"


@interface DashBoardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *score;
@end

@implementation DashBoardViewController {
    NSArray *finished;
    NSArray *expected;
    NSArray *tableData;
    NSArray *thumbnails;
    double healthScore;
    UIColor* defaultColor;
}

@synthesize score = _score;
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
    
    //UI modification
    self.navigationController.navigationBar.barTintColor = [DEFAULT_COLOR_GREEN;
//    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Apple SD Gothic Neo" size:19]}];
        
    
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
   
    self.largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(67.0f, 110.0f, 180.0f, 180.0f)];
                                                            
    healthScore = [self calculateScore:finished :expected];
    [self setDefaultColor];
    _score.textColor = defaultColor;
    [[self largestProgressView]setProgressTintColor:defaultColor];
    NSLog(@"health score is %f", healthScore);
    [self.view addSubview: self.largestProgressView];
    
    thumbnails = [NSArray arrayWithObjects:@"heart_green", @"sleep_green", @"steps", @"water_green", @"weight_green",nil];
    
    expected = [NSArray arrayWithObjects: [NSNumber numberWithInt:80], [NSNumber numberWithInt:8], [NSNumber numberWithInt:1200], [NSNumber numberWithInt:6],[NSNumber numberWithInt:20],nil];
    tableData = [NSArray arrayWithObjects:@"heartrate", @"sleep", @"step", @"cups", @"weight",nil];

    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(numberChange:) userInfo:nil repeats:YES];
                                                            //add shadow
                                                            self.dashTable.layer.shadowColor = [UIColor darkGrayColor].CGColor;
                                                            
                                                            self.dashTable.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
                                                            
                                                            self.dashTable.layer.shadowOpacity = 0.4;
                                                            
                                                            self.dashTable.layer.shadowRadius = 5.0f;
                                                            
                                                            self.dashTable.clipsToBounds = NO;
                                                            
                                                            self.dashTable.layer.masksToBounds = NO;

}
         
         
-(void) setDefaultColor{
    if (healthScore * 100 < 60) {
        defaultColor = [DEFAULT_COLOR_RED;
    } else if (healthScore * 100 < 80) {
        defaultColor = [DEFAULT_COLOR_YELLOW;
    } else {
        defaultColor = [DEFAULT_COLOR_GREEN;
    }
}
                        

- (void)progressChange
{
    if (_largestProgressView.progress < healthScore){
        _largestProgressView.progress += 0.003;
    }
    
    if (_largestProgressView.progress > 1.0f)
    {
        _largestProgressView.progress = 0.0f;
    }
}
                        
- (void)numberChange:(NSTimer *)timer {
    NSInteger value = _score.text.integerValue;
    if (value > healthScore * 100){
    } else if (value > healthScore * 100 - 3){
        value = healthScore * 100;
    } else {
        value += 3;
    }
    _score.text = [NSString stringWithFormat:@"%ld",(long)value];
}


-(double) calculateScore:(NSArray *) finish :(NSArray *)expect {
//    int sum_finish = 0;
//    int sum_expected = 0;
//    for (NSNumber * n in finish) {
//        sum_finish = [n integerValue];
//    }
//    for (NSNumber * m in expect) {
//        sum_expected = [m integerValue];
//    }
   
    return 0.7;
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
    UIColor* tintColor = [DEFAULT_COLOR_GREEN;
    if (z * 100 < 60) {
        tintColor = [DEFAULT_COLOR_RED;
    } else if (z * 100 < 80) {
        tintColor = [DEFAULT_COLOR_YELLOW;
    }
    cell.progress.progressTintColor = tintColor;
    
    cell.healthIconImage.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    [[cell healthIconImage]setTintColor:[UIColor lightGrayColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"HealthDataSegue"]) {
        
        NSIndexPath *indexPath = [self.dashTable indexPathForSelectedRow];
        
        DetailViewController *destViewController = segue.destinationViewController;
        NSString *healthDataName = [tableData objectAtIndex:indexPath.row];
        
        destViewController.healthDataName = healthDataName;
        
        
//        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
//        Recipe *recipe = [[Recipe alloc] init];
//        recipe.name = [object objectForKey:@"name"];
//        recipe.imageFile = [object objectForKey:@"imageFile"];
//        recipe.prepTime = [object objectForKey:@"prepTime"];
//        recipe.ingredients = [object objectForKey:@"ingredients"];
//        destViewController.recipe = recipe;
        
    }
}


@end

