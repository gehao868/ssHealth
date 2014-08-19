//
//  ImproveTableViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 8/2/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "ImproveTableViewController.h"
#import "ImproveTableViewCell.h"
#import "HealthTime.h"
#import "UserData.h"
#import <EventKit/EventKit.h>

@interface ImproveTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ImproveTableViewController
{
    NSMutableArray *goalArray;
    NSMutableArray *goalNumber;
    NSMutableArray *goalType;
    NSMutableArray *thumbnails;
    NSDate *today;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // check already added
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"name" equalTo:[UserData getUsername]];

    [query whereKey:@"date" greaterThanOrEqualTo:[HealthTime getToday]];
    [query whereKey:@"date" lessThanOrEqualTo:[HealthTime getTomorrow]];
    
    NSArray* objects = [query findObjects];
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    
    for (PFObject *object in objects) {
        [mutableDict setValue:@"yes"forKey:[object objectForKey:@"type"]];
    }
    
    // recomend step
    
    NSLog(@"step number is %d", [[HealthData getStep] intValue]);

    
    goalArray = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    goalNumber =[[NSMutableArray alloc] init];
    goalType = [[NSMutableArray alloc] init];
    
    if ([[HealthData getStep] intValue] < 8000 && [mutableDict objectForKey:@"step"] == nil) {
        int quota =[[HealthData getStep] intValue]+ 1000;
        [goalArray addObject:[NSString stringWithFormat:@"Walk %d steps", quota]];
        [thumbnails addObject:@"step"];
        [goalNumber addObject:[NSNumber numberWithInt:quota]];
        [goalType addObject:@"step"];
    }
    
    // recommend sleep
    
    if ([[HealthData getSleep] intValue] < 420 && [mutableDict objectForKey:@"sleep"]== nil){
        int quota =([[HealthData getSleep] intValue] + 60)/60;
        [goalArray addObject:[NSString stringWithFormat:@"Sleep %d hours", quota]];
        [thumbnails addObject:@"sleep"];
        [goalNumber addObject:[NSNumber numberWithInt:quota]];
        [goalType addObject:@"sleep"];
        
    } else if ([[HealthData getSleep] intValue] > 540 &&[mutableDict objectForKey:@"sleep"]== nil) {
        int quota =([[HealthData getSleep] intValue] - 60)/60;
        [goalArray addObject:[NSString stringWithFormat:@"Sleep %d hours", quota]];
        [thumbnails addObject:@"sleep"];
        [goalNumber addObject:[NSNumber numberWithInt:quota]];
        [goalType addObject:@"sleep"];
    }
    
    // recommend bodyfat
    
    if ([[HealthData getFatratio] floatValue] > 31 && [mutableDict objectForKey:@"fatratio"]== nil){
        [goalArray addObject:[NSString stringWithFormat:@"Exercies 30 minutes"]];
        [thumbnails addObject:@"fatratio"];
        [goalNumber addObject:[NSNumber numberWithInt:30]];
        [goalType addObject:@"fatratio"];
    }
    
    // cups
    
    if ([[UserData getGender] isEqualToString:@"female"]) {
        if ([[HealthData getCups] intValue] < 8 && [mutableDict objectForKey:@"cups"]== nil){
            int quota =[[HealthData getCups] intValue] + 1;
            [goalArray addObject:[NSString stringWithFormat:@"Drink %d cups of water", quota]];
            [thumbnails addObject:@"cups"];
            [goalNumber addObject:[NSNumber numberWithInt:quota]];
            [goalType addObject:@"cups"];
        }
    } else if ([[UserData getGender] isEqualToString:@"male"]) {
        if ([[HealthData getCups] intValue] < 13 && [mutableDict objectForKey:@"cups"]== nil){
            int quota =[[HealthData getCups] intValue] + 1;
            [goalArray addObject:[NSString stringWithFormat:@"Drink %d cups of water", quota]];
            [thumbnails addObject:@"cups"];
            [goalNumber addObject:[NSNumber numberWithInt:quota]];
            [goalType addObject:@"cups"];
        }
    }
    
    //bmi
    
    if ([[HealthData getBMI] intValue] > 25 && [mutableDict objectForKey:@"weight"]==nil) {
        [goalArray addObject:[NSString stringWithFormat:@"Exercies 30 minutes"]];
        [thumbnails addObject:@"weight"];
        [goalNumber addObject:[NSNumber numberWithInt:30]];
        [goalType addObject:@"weight"];
    }
    
    
    // heartrate
    if ([[HealthData getHeartrate] intValue] >100 && [mutableDict objectForKey:@"heartrate"] == nil) {
        [goalArray addObject:[NSString stringWithFormat:@"Exercies 30 minutes"]];
        [thumbnails addObject:@"hearrate"];
        [goalNumber addObject:[NSNumber numberWithInt:30]];
        [goalType addObject:@"heartrate"];
    }
    self.headLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.headLabel.numberOfLines = 0;
    if ([goalArray count] == 0) {
        [self.headLabel setText:@"Well done! You've add all goals! Keep on going!"];
    } else {
        [self.headLabel setText:@"Add goals to become the best version of yourself!"];
    }
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [goalArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ImproveCell";
    
    ImproveTableViewCell *cell = (ImproveTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ImproveCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.improveLabel.text = [goalArray objectAtIndex:indexPath.row];
    cell.improveImage.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [DEFAULT_COLOR_THEME];
    cell.selectedBackgroundView = myBackView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *type = [goalType objectAtIndex:indexPath.row];
    if ([type isEqualToString:@"fatratio"]||[type isEqualToString:@"weight"]||[type isEqualToString:@"heartrate"]) {
        for (int i = 0; i < 21; i++) {
            PFObject *goal =[PFObject objectWithClassName:@"Goal"];
            goal[@"expected"] = [goalNumber objectAtIndex:indexPath.row];
            goal[@"type"] = type;
            goal[@"date"] = [[HealthTime getToday] dateByAddingTimeInterval:60*60*24*i];
            goal[@"name"] = [UserData getUsername];
            goal[@"done"] = @"no";
            [goal saveInBackground];
        }
    } else {
    
        PFObject *goal =[PFObject objectWithClassName:@"Goal"];
        goal[@"expected"] = [goalNumber objectAtIndex:indexPath.row];
        goal[@"type"] = [goalType objectAtIndex:indexPath.row];
        goal[@"date"] = [HealthTime getToday];
        goal[@"name"] = [UserData getUsername];
        goal[@"done"] = @"no";
        [goal saveInBackground];
    
    
    }
    
    ImproveTableViewCell *cell = (ImproveTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    cell.improveAdd.image = [UIImage imageNamed:@"checkmark_black"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


@end
