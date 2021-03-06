//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DashBoardViewController.h"
#import "HealthData.h"
#import "HealthTime.h"
#import "UserData.h"
#import "Global.h"
#import "DashTableViewCell.h"
#import "DetailViewController.h"


@interface DashBoardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *heartrate;
@property (weak, nonatomic) IBOutlet UILabel *sleep;
@property (weak, nonatomic) IBOutlet UILabel *step;
@property (weak, nonatomic) IBOutlet UILabel *cups;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *bodyfat;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation DashBoardViewController {
    NSArray *thumbnails;
    NSMutableArray *subScore;
    NSArray * subCircleLabel;
    NSMutableArray *subTimers;
    double healthScore;
    UIColor* defaultColor;
    int healthScoreInt;
    NSDictionary *subIndexDict;
    NSArray* objects;
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
    
    self.navigationController.navigationBar.barTintColor = [DEFAULT_COLOR_THEME];

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Apple SD Gothic Neo" size:19]}];
    subIndexDict = [NSDictionary dictionaryWithObjectsAndKeys:@"heartrate", [NSNumber numberWithInt:0], @"sleep", [NSNumber numberWithInt:1], @"step", [NSNumber numberWithInt:2], @"cups", [NSNumber numberWithInt:3], @"weight", [NSNumber numberWithInt:4], @"bodyfat", [NSNumber numberWithInt:5], nil];
    
    PFQuery *newsQuery = [PFQuery queryWithClassName:@"News"];
    [newsQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            NSString *username = [UserData getUsername];
            for (PFObject *object in results) {
                if ([[object objectForKey:@"postusername"] isEqualToString:username]) {
                    NSNumber *num = [object objectForKey:@"showlikenum"];
                    [Global setShowlikenum:[Global getShowlikenum] + [num integerValue]];
                    object[@"showlikenum"] = @0;
                    [object saveInBackground];
                }
            }
            
            if ([Global getShowlikenum] > 0) {
                //[self.liked setHidden:NO];
                [self.liked setEnabled:YES];
                [self.liked setBackgroundImage:[UIImage imageNamed:@"heart_filled"] forState:UIControlStateNormal];
                [self.liked setTitle:[NSString stringWithFormat:@"%d", [Global getShowlikenum]] forState:UIControlStateNormal];
            } else {
                //[self.liked setHidden:YES];
                [self.liked setEnabled:NO];
                [self.liked setBackgroundImage:[UIImage imageNamed:@"heart_white"] forState:UIControlStateNormal];
                [self.liked setTitle:@"0" forState:UIControlStateNormal];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    NSDate *today = [NSDate date];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    
    
    //[components setHour:-4];
    
    [components setHour:-4];
    [components setMinute:0];
    [components setSecond:0];
    
    today = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    [HealthTime setToday:today];
    [HealthTime setTomorrow:[today dateByAddingTimeInterval:60*60*24*1]];
    
    subScore = [[NSMutableArray alloc] init];
    subCircleLabel = [NSArray arrayWithObjects:_heartrate,_sleep,_step, _cups, _weight, _bodyfat, nil];
    
    int heartrate = 0;
    int cups = 0;
    int step = 0;
    int losedWeight = 0;
    float bmi = 0;
    int sleep = 0;
    int fatratio = 0;
    
    if ([HealthData getHeartrate] == nil || [HealthData getStep] == nil || [HealthData getSleep] == nil || [HealthData getCups] == nil ||[HealthData getBMI] == nil || [HealthData getFatratio] == nil) {
    
        PFQuery *query = [PFQuery queryWithClassName:@"HealthData"];
        [query whereKey:@"username" equalTo:[UserData getUsername]];
        
        [query whereKey:@"date" lessThanOrEqualTo:[HealthTime getToday]];
        [query whereKey:@"date" greaterThanOrEqualTo:[today dateByAddingTimeInterval:-60*60*24*1]];
        
        objects = [query findObjects];
        
        if ([objects count] != 0) {
            int i = [objects count] - 1;
            [HealthData setActive:[objects[i] objectForKey:@"active"]];
            [HealthData setAsleep:[objects[i] objectForKey:@"asleep"]];
            
            heartrate = [[objects[i] objectForKey:@"heartrate"] intValue];
            [HealthData setHeartrate:[objects[i] objectForKey:@"heartrate"]];

            cups = [[objects[i] objectForKey:@"cups"] intValue];
            [HealthData setCups:[objects[i] objectForKey:@"cups"]];

            step = [[objects[i] objectForKey:@"step"] intValue];
            [HealthData setStep:[objects[i] objectForKey:@"step"]];
            
            losedWeight = [[objects[i] objectForKey:@"weight"] intValue];
            bmi = 1.0 * losedWeight / ([[UserData getHeight] intValue] * [[UserData getHeight] intValue] / 10000.0);
            [HealthData setBMI:[NSNumber numberWithFloat:bmi]];
            
            sleep = [[objects[i] objectForKey:@"sleep"] intValue];
            [HealthData setSleep:[objects[i] objectForKey:@"sleep"]];
            
            fatratio = [[objects[i] objectForKey:@"fatratio"] intValue];
            [HealthData setFatratio:[objects[i] objectForKey:@"fatratio"]];
        }
        
    } else {
        heartrate = [[HealthData getHeartrate] intValue];
        cups = [[HealthData getCups] intValue];
        step = [[HealthData getStep] intValue];
        bmi = [[HealthData getBMI] floatValue];
        sleep = [[HealthData getSleep] intValue];
        fatratio = [[HealthData getFatratio] intValue];
    }
    
    if(heartrate <= 100 && heartrate >= 40){
        [subScore addObject:[NSNumber numberWithFloat:1]];
    } else {
        [subScore addObject:[NSNumber numberWithFloat:0]];
    }
    
    if ([[UserData getGender] isEqualToString:@"male"]) {
        if (cups >=13) {
            [subScore addObject:[NSNumber numberWithFloat:1]];
        } else {
            [subScore addObject:[NSNumber numberWithFloat:cups/13.0]];
        }
    } else {
        if (cups >= 9 ) {
            [subScore addObject:[NSNumber numberWithFloat:1]];
        } else {
            [subScore addObject:[NSNumber numberWithFloat:cups/9.0]];
        }
    }

    if (step >= 8000) {
        [subScore addObject:[NSNumber numberWithFloat:1]];
    } else {
        [subScore addObject:[NSNumber numberWithFloat:1.0 * step/8000]];
    }

    if (bmi < 18) {
        [subScore addObject:[NSNumber numberWithFloat:0.7]];
    } else if (bmi > 30) {
        [subScore addObject:[NSNumber numberWithFloat:0.5]];
    } else if (bmi >25 && bmi <= 30) {
        [subScore addObject:[NSNumber numberWithFloat:0.7]];
    } else {
        [subScore addObject:[NSNumber numberWithFloat:1]];
    }

    if (sleep <= 540 && sleep >=420) {
        [subScore addObject:[NSNumber numberWithFloat:1]];
    } else if (sleep > 780 || sleep < 240){
        [subScore addObject:[NSNumber numberWithFloat:0]];
    } else if (sleep >540 && sleep <=780) {
        [subScore addObject:[NSNumber numberWithFloat:1.0 * (780-sleep)/240]];
    } else if (sleep >= 240 && sleep <420){
        [subScore addObject:[NSNumber numberWithFloat:1.0 * (sleep - 240)/240]];
    }
    
    if ([[UserData getGender] isEqualToString:@"male"]) {
        if (fatratio < 18) {
            [subScore addObject:[NSNumber numberWithFloat:1.0 * fatratio/18]];
        } else if (fatratio > 24){
            [subScore addObject:[NSNumber numberWithFloat:1.0 * (100-fatratio)/76]];
        } else {
            [subScore addObject:[NSNumber numberWithFloat:1]];
        }
    } else {
        if (fatratio < 25) {
            [subScore addObject:[NSNumber numberWithFloat:1.0 * fatratio/25]];
        } else if (fatratio > 31){
            [subScore addObject:[NSNumber numberWithFloat:1.0 * (100-fatratio)/69]];
        } else {
            [subScore addObject:[NSNumber numberWithFloat:1]];
        }
    }
    
    self.subProgessView = [[NSMutableArray alloc]init];

    int index = 0;
    for(int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++) {
            NSString *text = [[NSString alloc] initWithFormat:@"%2.0f%%",([[subScore objectAtIndex:index] floatValue]*100)];
            [[subCircleLabel objectAtIndex:j*3+i] setText:text];
            DACircularProgressView *tmpView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(12.0f + i * 108, 363.0f + 105.0f * j, 80.0f, 80.0f)];
            [tmpView setProgress:[[subScore objectAtIndex:index] floatValue]];
            [tmpView setProgressTintColor:[DEFAULT_COLOR_GREEN]];
            [self.subProgessView addObject:tmpView];
            [self.view addSubview:tmpView];
            [self.view bringSubviewToFront:self.buttonView];
            index++;
        }
    }
    
    self.largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(80.0f, 125.0f, 160.0f, 160.0f)];
    NSMutableArray *subCopy = [NSMutableArray arrayWithArray:subScore];;
    healthScore = [self calculateScore:subCopy];
    healthScoreInt = (int)roundf(healthScore * 100);
             
    [self setCheer:healthScoreInt];
    
    [self setDefaultColor];
    _score.textColor = defaultColor;
    [[self largestProgressView]setProgressTintColor:defaultColor];
    [self.view addSubview: self.largestProgressView];

    thumbnails = [NSArray arrayWithObjects:@"heartrate", @"sleep", @"step", @"cups", @"weight",nil];
    

    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
             
    //add shadow
    self.dashTable.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.dashTable.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    self.dashTable.layer.shadowOpacity = 0.4;
    self.dashTable.layer.shadowRadius = 5.0f;
    self.dashTable.clipsToBounds = NO;
    self.dashTable.layer.masksToBounds = NO;
}
         
-(void) setCheer:(int)s {
    double u = 0;
    double o = 1;
    double convertedX = (healthScore - 0.65) * 10;
    double a = 4.0 / sqrt(2.0 * 3.1415926) / o;
    double ex = exp(a * (convertedX - u));
    int ret = (int)roundf(ex / (1 + ex) * 100);
    self.cheerNumberLabel.text = [NSString stringWithFormat:@"You are better than %d%% users",ret];
    if (s >= 80) {
        self.cheerLabel.text = @"Well done";
    } else if (s <80 && s>=50) {
        self.cheerLabel.text = @"Good job";
    } else {
        self.cheerLabel.text = @"Try hard";
    }
}
             
-(void) setDefaultColor{
    if (healthScore * 100 < 60) {
        defaultColor = [DEFAULT_COLOR_RED];
    } else if (healthScore * 100 < 80) {
        defaultColor = [DEFAULT_COLOR_YELLOW];
    } else {
        defaultColor = [DEFAULT_COLOR_THEME];
    }
}
                        

- (void)progressChange
{
    float score =_largestProgressView.progress;
    if (score < healthScore - 0.003){
        _largestProgressView.progress += 0.003f;
        _score.text = [NSString stringWithFormat:@"%d", (int)roundf(_largestProgressView.progress * 100)];
    } else {
        _largestProgressView.progress = healthScore;
        _score.text = [NSString stringWithFormat:@"%d", healthScoreInt];
    }
    
}



-(double) calculateScore:(NSMutableArray *) subScoreArray {
    NSSortDescriptor *lowToHigh = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [subScoreArray sortUsingDescriptors:[NSArray arrayWithObject:lowToHigh]];
    
    NSArray *gradient  = [NSArray arrayWithObjects:[NSNumber numberWithDouble:0.4], [NSNumber numberWithDouble:0.2],[NSNumber numberWithDouble:0.1],[NSNumber numberWithDouble:0.1],[NSNumber numberWithDouble:0.1],[NSNumber numberWithDouble:0.1],nil];
    
    double score = 0.0;
    
    for (int i = 0; i < [subScoreArray count]; i++) {
        score = score + [[subScoreArray objectAtIndex:i] floatValue] * [[gradient objectAtIndex:i] doubleValue];
    }
    return score;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    [tableView deselectRowAtIndexPath:newIndexPath animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailViewController *destViewController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"sleep"]) {
        destViewController.healthDataName = @"sleep";
        destViewController.dataValue = [HealthData getSleep];
    
    } else if ([segue.identifier isEqualToString:@"step"]) {
        destViewController.healthDataName = @"step";
        destViewController.dataValue = [HealthData getStep];
        
    } else if ([segue.identifier isEqualToString:@"weight"]) {
        destViewController.healthDataName = @"weight";
        destViewController.dataValue = [HealthData getBMI];
        
    } else if ([segue.identifier isEqualToString:@"fatratio"]) {
        destViewController.healthDataName = @"fatratio";
        destViewController.dataValue = [HealthData getFatratio];

    } else if ([segue.identifier isEqualToString:@"heartrate"]) {
        destViewController.healthDataName = @"heartrate";
        destViewController.dataValue = [HealthData getHeartrate];
        
    } else if ([segue.identifier isEqualToString:@"cups"]) {
        destViewController.healthDataName = @"cups";
        destViewController.dataValue = [HealthData getCups];
    }
}

- (IBAction)likedAction:(id)sender {
    //[self.liked setHidden:YES];
    [self.liked setEnabled:NO];
    [self.liked setBackgroundImage:[UIImage imageNamed:@"heart_white"] forState:UIControlStateNormal];
    [self.liked setTitle:@"0" forState:UIControlStateNormal];
    
    NSInteger showlikenum = [Global getShowlikenum];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congratulations!" message:[NSString stringWithFormat:@"You recieved %d likes,\nand earned %d points.", showlikenum, showlikenum * 10] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alertView show];
    
    [UserData setPoint:[NSNumber numberWithInteger:[[UserData getPoint] integerValue] + showlikenum * 10]];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"username" equalTo:[UserData getUsername]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        user[@"point"] = [UserData getPoint];
        [user saveInBackground];
    }];
    
    [Global setShowlikenum:0];
}

@end


