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
    
    self.navigationController.navigationBar.barTintColor = [DEFAULT_COLOR_THEME;

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
                [self.liked setEnabled:YES];
                [self.liked setBackgroundImage:[UIImage imageNamed:@"heart_filled"] forState:UIControlStateNormal];
                [self.liked setTitle:[NSString stringWithFormat:@"%d", [Global getShowlikenum]] forState:UIControlStateNormal];
            } else {
                [self.liked setEnabled:NO];
                [self.liked setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
                [self.liked setTitle:nil forState:UIControlStateNormal];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
                                                            
    PFQuery *query = [PFQuery queryWithClassName:@"HealthData"];
    [query whereKey:@"username" equalTo:[UserData getUsername]];

                                            
    NSDate *today = [NSDate date];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    [components setHour:-4];
    today = [[NSCalendar currentCalendar] dateFromComponents:components];
                                                            [HealthTime setToday:today];
                                                            [HealthTime setTomorrow:[today dateByAddingTimeInterval:60*60*24*1]];
                                                            
    [query whereKey:@"date" lessThanOrEqualTo:[HealthTime getTomorrow]];
    [query whereKey:@"date" greaterThanOrEqualTo:today];
    
    subCircleLabel = [NSArray arrayWithObjects:_heartrate,_sleep,_step, _cups, _weight, _bodyfat, nil];
    
                                                            
    objects = [query findObjects];
                                                            

                                    
    subScore = [[NSMutableArray alloc] init];
                                                            

                                                            if ([objects count] == 0) {
                                                                [subScore addObject:[NSNumber numberWithFloat:0]];
                                                            } else {
                                                                int i = [objects count] - 1;
                                                                    int heartrate = [[objects[i] objectForKey:@"heartrate"] intValue];
                                                                    [HealthData setHeartrate:[objects[i] objectForKey:@"heartrate"]];
                                                                    
                                                                    if(heartrate <= 100 && heartrate >= 40){
                                                                        [subScore addObject:[NSNumber numberWithFloat:1]];
                                                                    } else {
                                                                        [subScore addObject:[NSNumber numberWithFloat:0]];
                                                                    }
                                                                    
                                                                    int cups = [[objects[i] objectForKey:@"cups"] intValue];
                                                                     [HealthData setCups:[objects[i] objectForKey:@"cups"]];
                                                                    
                                                                    if ([[UserData getGender] isEqualToString:@"male"]) {
                                                                        if (cups >=13) {
                                                                            [subScore addObject:[NSNumber numberWithFloat:1]];
                                                                        } else {
                                                                            NSLog(@"CUPS IS %f", fabsf(1.0 *(cups - 13)/13));
                                                                            [subScore addObject:[NSNumber numberWithFloat:0.4]];
                                                                        }
                                                                    } else {
                                                                        if (cups >= 9 ) {
                                                                            [subScore addObject:[NSNumber numberWithFloat:1]];
                                                                        } else {
                                                                            [subScore addObject:[NSNumber numberWithFloat:fabsf(1.0 * (cups - 9)/9)]];
                                                                        }
                                                                    }
                                                                    
                                                                    int step = [[objects[i] objectForKey:@"step"] intValue];
                                                                    [HealthData setStep:[objects[i] objectForKey:@"step"]];
                                                                    
                                                                    if (step >= 8000) {
                                                                        [subScore addObject:[NSNumber numberWithFloat:1]];
                                                                    } else {
                                                                        [subScore addObject:[NSNumber numberWithFloat:1.0 * step/8000]];
                                                                    }
                                                                    
                                                                    int losedWeight = [[objects[i] objectForKey:@"weight"] intValue];
                                                                    float bmi = 1.0 * losedWeight / [[UserData getHeight] intValue] * [[UserData getHeight] intValue];
                                                                    [HealthData setBMI:[NSNumber numberWithFloat:bmi]];
                                                                    
                                                                    if (bmi < 18) {
                                                                        [subScore addObject:[NSNumber numberWithFloat:0.7]];
                                                                    } else if (bmi > 30) {
                                                                        [subScore addObject:[NSNumber numberWithFloat:0.5]];
                                                                    } else if (bmi >25 && bmi <= 30) {
                                                                        [subScore addObject:[NSNumber numberWithFloat:0.7]];
                                                                    } else {
                                                                        [subScore addObject:[NSNumber numberWithFloat:1]];
                                                                    }
                                                                    
                                                                    int sleep = [[objects[i] objectForKey:@"sleep"] intValue];
                                                                    [HealthData setSleep:[objects[i] objectForKey:@"sleep"]];
                                                                    
                                                                    if (sleep <= 540 && sleep >=420) {
                                                                        [subScore addObject:[NSNumber numberWithFloat:1]];
                                                                    } else if (sleep > 780 || sleep < 240){
                                                                        [subScore addObject:[NSNumber numberWithFloat:0]];
                                                                    } else if (sleep >540 && sleep <=780) {
                                                                        [subScore addObject:[NSNumber numberWithFloat:1.0 * (780-sleep)/240]];
                                                                    } else if (sleep >= 240 && sleep <420){
                                                                        [subScore addObject:[NSNumber numberWithFloat:1.0 * (sleep - 240)/240]];
                                                                    }
                                                                    
                                                                    int fatratio = [[objects[i] objectForKey:@"fatratio"] intValue];
                                                                    [HealthData setFatratio:[objects[i] objectForKey:@"fatratio"]];
                                                                    
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
                                                                    
                                                                
                                                               
                                                            }
                                                            
                                                            
    self.subProgessView = [[NSMutableArray alloc]init];

    int index = 0;
    for(int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++) {
            NSString *text = [[NSString alloc] initWithFormat:@"%2.0f%%",([[subScore objectAtIndex:index] floatValue]*100)];
            [[subCircleLabel objectAtIndex:j*3+i] setText:text];
            DACircularProgressView *tmpView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(10.0f + i * 108, 363.0f + 105.0f * j, 80.0f, 80.0f)];
            [tmpView setProgress:[[subScore objectAtIndex:index] floatValue]];
            [tmpView setProgressTintColor:[DEFAULT_COLOR_GREEN];
            [self.subProgessView addObject:tmpView];
            [self.view addSubview:tmpView];
            [self.view bringSubviewToFront:self.buttonView];
            index++;
        }
    }
             self.largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(70.0f, 115.0f, 180.0f, 180.0f)];
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
         
-(void) setCheer:(int) s{
    if (s >= 80) {
        self.cheerLabel.text = @"Well done";
        self.cheerNumberLabel.text = @"You are better than 90% users";
    } else if (s <80 && s>=50) {
        self.cheerLabel.text = @"Good job";
        self.cheerNumberLabel.text = @"You are better than 70% users";
    } else {
        self.cheerLabel.text = @"Try hard";
        self.cheerNumberLabel.text = @"You are better than 30% users";
    }
}
             
-(void) setDefaultColor{
    if (healthScore * 100 < 60) {
        defaultColor = [DEFAULT_COLOR_RED;
    } else if (healthScore * 100 < 80) {
        defaultColor = [DEFAULT_COLOR_YELLOW;
    } else {
        defaultColor = [DEFAULT_COLOR_THEME;
    }
}
                        

- (void)progressChange
{
    int score = (int)roundf(_largestProgressView.progress * 100);
   // int curScore = _score.text.intValue;
    
    if (healthScoreInt > _score.text.intValue && score > _score.text.intValue) {
        score += 1;
        _score.text = [NSString stringWithFormat:@"%d",score];
    } else if (healthScoreInt < _score.text.intValue) {
        _score.text = [NSString stringWithFormat:@"%d",healthScoreInt];
    }
    
    if (_largestProgressView.progress < healthScore){
        _largestProgressView.progress += 0.003f;
    }
    if (_largestProgressView.progress > 1.0f)
    {
        _largestProgressView.progress = 0.0f;
    }
    
}

- (void)subProgressChange1:(NSTimer*)timer
{
            NSNumber* index = (NSNumber*)[timer userInfo];
            DACircularProgressView * tmpView= _subProgessView[index.intValue];
    NSNumber *score = (NSNumber*)[subScore objectAtIndex:index.intValue];
    
            if (tmpView.progress < score.floatValue){
                tmpView.progress += 0.003;
            }
            
            if (tmpView.progress > 1.0f)
            {
                tmpView.progress = 0.0f;
            }
        }
                        
                        - (void)subProgressChange2:(NSTimer*)timer
        {
            NSNumber* index = (NSNumber*)[timer userInfo];
            DACircularProgressView * tmpView= _subProgessView[index.intValue];
            NSNumber *score = (NSNumber*)[subScore objectAtIndex:index.intValue];
            
            if (tmpView.progress < score.floatValue){
                tmpView.progress += 0.003;
            }
            
            if (tmpView.progress > 1.0f)
            {
                tmpView.progress = 0.0f;
            }
        }
                        
                        - (void)subProgressChange3:(NSTimer*)timer
        {
            NSNumber* index = (NSNumber*)[timer userInfo];
            DACircularProgressView * tmpView= _subProgessView[index.intValue];
            NSNumber *score = (NSNumber*)[subScore objectAtIndex:index.intValue];
            
            if (tmpView.progress < score.floatValue){
                tmpView.progress += 0.003;
            }
            
            if (tmpView.progress > 1.0f)
            {
                tmpView.progress = 0.0f;
            }
        }

                        - (void)subProgressChange4:(NSTimer*)timer
        {
            NSNumber* index = (NSNumber*)[timer userInfo];
            DACircularProgressView * tmpView= _subProgessView[index.intValue];
            NSNumber *score = (NSNumber*)[subScore objectAtIndex:index.intValue];
            
            if (tmpView.progress < score.floatValue){
                tmpView.progress += 0.003;
            }
            
            if (tmpView.progress > 1.0f)
            {
                tmpView.progress = 0.0f;
            }
        }
                        - (void)subProgressChange5:(NSTimer*)timer
        {
            NSNumber* index = (NSNumber*)[timer userInfo];
            DACircularProgressView * tmpView= _subProgessView[index.intValue];
            NSNumber *score = (NSNumber*)[subScore objectAtIndex:index.intValue];
            
            if (tmpView.progress < score.floatValue){
                tmpView.progress += 0.003;
            }
            
            if (tmpView.progress > 1.0f)
            {
                tmpView.progress = 0.0f;
            }
        }

                        - (void)subProgressChange0:(NSTimer*)timer
        {
            NSNumber* index = (NSNumber*)[timer userInfo];
            DACircularProgressView * tmpView= _subProgessView[index.intValue];
            NSNumber *score = (NSNumber*)[subScore objectAtIndex:index.intValue];
            
            if (tmpView.progress < score.floatValue){
                tmpView.progress += 0.003;
            }
            
            if (tmpView.progress > 1.0f)
            {
                tmpView.progress = 0.0f;
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
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
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
    [self.liked setEnabled:NO];
    [self.liked setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [self.liked setTitle:nil forState:UIControlStateNormal];
    
    NSInteger showlikenum = [Global getShowlikenum];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congratulations!" message:[NSString stringWithFormat:@"You recieved %d hearts,\nand earned %d scores.", showlikenum, showlikenum * 10] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
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


