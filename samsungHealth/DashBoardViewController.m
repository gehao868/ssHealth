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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:70.0f/255.0f green:160.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    
    self.largestProgressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(67.0f, 110.0f, 180.0f, 180.0f)];
    [self.view addSubview: self.largestProgressView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    
    // Initialize table data
    tableData = [NSArray arrayWithObjects:@"56%", @"100%", @"100%", @"75%", @"80%", nil];
    
    // Initialize thumbnails
    thumbnails = [NSArray arrayWithObjects:@"heart_green", @"sleep_green", @"steps", @"water_green", @"weight_green",nil];
    
    
    
    // Find out the path of recipes.plist

    
    
    
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
    return [tableData count];
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
    
    
    cell.output.text = [tableData objectAtIndex:indexPath.row];
    cell.healthIconImage.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    /*UIAlertView *messageAlert = [[UIAlertView alloc]
     initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];*/
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:[tableData objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [messageAlert show];
    
    // Checked the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willSelectRowAtIndexPath");
    if (indexPath.row == 0) {
        return nil;
    }
    
    return indexPath;
}


@end

