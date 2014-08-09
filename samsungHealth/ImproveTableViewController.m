//
//  ImproveTableViewController.m
//  samsungHealth
//
//  Created by Hao Ge on 8/2/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "ImproveTableViewController.h"
#import "ImproveTableViewCell.h"

@interface ImproveTableViewController ()

@end

@implementation ImproveTableViewController
{
    NSArray *tableData;
    NSArray *thumbnails;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
	// Initialize table data
    tableData = [NSArray arrayWithObjects:@"1000", @"300", @"8", nil];
    
    // Initialize thumbnails
    thumbnails = [NSArray arrayWithObjects:@"steps", @"food_green", @"sleep_green", nil];
    
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
    return [tableData count];
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
    
    cell.improveLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.improveImage.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    /*UIAlertView *messageAlert = [[UIAlertView alloc]
     initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];*/
    
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Goal added!" message:[tableData objectAtIndex:indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [messageAlert show];
    
    // Checked the selected row
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    
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
