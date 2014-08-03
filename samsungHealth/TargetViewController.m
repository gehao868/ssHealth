//
//  DEMOSecondViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "TargetViewController.h"
#import "GoalTableCell.h"

@interface TargetViewController ()

@end

@implementation TargetViewController {
    NSArray *finished;
    NSArray *expected;
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
//    [calendar setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
//    [forward setImage:[UIImage imageNamed:@"forward_grey"] forState:UIControlStateNormal];
//    [back setImage:[UIImage imageNamed:@"back_grey"] forState:UIControlStateNormal];
    
    [calendar setBackgroundImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [calendar setTitle:@"" forState:UIControlStateNormal];
    [forward setBackgroundImage:[UIImage imageNamed:@"forward_grey"] forState:UIControlStateNormal];
    [forward setTitle:@"" forState:UIControlStateNormal];
    [back setBackgroundImage:[UIImage imageNamed:@"back_grey"] forState:UIControlStateNormal];
    [back setTitle:@"" forState:UIControlStateNormal];
//    calender.image = [UIImage imageNamed:@"calendar"];
//    forward.image = [UIImage imageNamed:@"forward_grey"];
//    back.image = [UIImage imageNamed:@"back_grey"];
    font = [UIFont systemFontOfSize:20.0f];
    imgList = [NSMutableArray arrayWithObjects:@"steps", @"food_green", @"sleep_green", nil];
    finished = [NSArray arrayWithObjects: [NSNumber numberWithInt:2700], [NSNumber numberWithInt:800], [NSNumber numberWithInt:1800], nil];
    expected = [NSArray arrayWithObjects: [NSNumber numberWithInt:3000], [NSNumber numberWithInt:1000], [NSNumber numberWithInt:2000], nil];
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
