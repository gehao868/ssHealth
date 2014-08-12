//
//  ImproveTableViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 8/2/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "ImproveTableViewController.h"
#import "ImproveTableViewCell.h"
#import "UserData.h"

@interface ImproveTableViewController ()

@end

@implementation ImproveTableViewController
{
    NSMutableArray *goalArray;
    NSMutableArray *goalNumber;
    NSMutableArray *goalType;
    NSMutableArray *thumbnails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // check already added
    
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
    //[query whereKey:@"date" lessThanOrEqualTo:today];
    [query whereKey:@"date" greaterThan:yesterday];
    
    NSArray* objects = [query findObjects];
    
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    
    NSLog(@"ENTER FOR LOOP");
    
    for (PFObject *object in objects) {
        NSLog(@"inSIDE  LOOP");
        NSLog(@"%@", [object objectForKey:@"type"]);
        [mutableDict setValue:@"yes"forKey:[object objectForKey:@"type"]];
    }
    
    
    NSLog(@"END FOR LOOP");
    // continue
    
    // recomend step
    
    goalArray = [[NSMutableArray alloc] init];
    thumbnails = [[NSMutableArray alloc] init];
    goalNumber =[[NSMutableArray alloc] init];
    goalType = [[NSMutableArray alloc] init];
    
    if ([[[self healthData] step] intValue] < 8000 && [mutableDict objectForKey:@"stepcount"] == nil) {
        int quota =[[[self healthData] step] intValue] + 1000;
        [goalArray addObject:[NSString stringWithFormat:@"Walk %d steps", quota]];
        [thumbnails addObject:@"steps"];
        [goalNumber addObject:[NSNumber numberWithInt:quota]];
        [goalType addObject:@"step"];
    }
    
    // recommend sleep
    
    if ([[[self healthData] sleep] intValue] < 7 && [mutableDict objectForKey:@"sleep"]== nil){
        int quota =[[[self healthData] sleep] intValue] + 1;
        [goalArray addObject:[NSString stringWithFormat:@"Sleep %d hours", quota]];
        [thumbnails addObject:@"sleep_green"];
        [goalNumber addObject:[NSNumber numberWithInt:quota]];
        [goalType addObject:@"sleep"];
        
    } else if ([[[self healthData] sleep] intValue] > 9 &&[mutableDict objectForKey:@"sleep"]== nil) {
        int quota =[[[self healthData] sleep] intValue] - 1;
        [goalArray addObject:[NSString stringWithFormat:@"Sleep %d hours", quota]];
        [thumbnails addObject:@"sleep_green"];
        [goalNumber addObject:[NSNumber numberWithInt:quota]];
        [goalType addObject:@"sleep"];
    }
    
    // recommend bodyfat
    
    if ([[[self healthData] fatratio] floatValue] > 31 && [mutableDict objectForKey:@"fatratio"]== nil){
        [goalArray addObject:[NSString stringWithFormat:@"Exercies 30 minutes"]];
        [thumbnails addObject:@"bodyfat_goal"];
        [goalNumber addObject:[NSNumber numberWithInt:30]];
        [goalType addObject:@"fatratio"];
    }
    
    // cups
    if ([[[self healthData] cups] intValue] < 8 && [mutableDict objectForKey:@"cups"]== nil){
        int quota =[[[self healthData] cups] intValue] + 1;
        [goalArray addObject:[NSString stringWithFormat:@"Drink %d cups of water", quota]];
        [thumbnails addObject:@"water_goal"];
        [goalNumber addObject:[NSNumber numberWithInt:quota]];
        [goalType addObject:@"cups"];
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    PFObject *goal =[PFObject objectWithClassName:@"Goal"];
    goal[@"expected"] = [goalNumber objectAtIndex:indexPath.row];
    goal[@"type"] = [goalType objectAtIndex:indexPath.row];
    goal[@"date"] = [NSDate date];
    goal[@"name"] = [UserData getUsername];
    
    [goal saveInBackground];

    ImproveTableViewCell *cell = (ImproveTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    cell.improveAdd.image = [UIImage imageNamed:@"checkmark_black"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"willSelectRowAtIndexPath");
//    if (indexPath.row == 0) {
//        return nil;
//    }
//    
//    return indexPath;
//}


@end
