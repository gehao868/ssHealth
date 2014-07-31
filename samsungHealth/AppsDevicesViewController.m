//
//  AppsDevicesViewController.m
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <Parse/Parse.h>
#import <OAuthiOS/OAuthiOS.h>
#import "AppsDevicesViewController.h"
#import "AppDeviceTableViewCell.h"

@interface AppsDevicesViewController ()

@end

static NSString * const OAuthKeyForFitbit = @"s0ROr_j8tXMhlAfwlPQ4SXKQWQM";
static NSString * userid = NULL;
static NSString * username = NULL;
static NSMutableData * responseData;
@implementation AppsDevicesViewController
{
    NSMutableArray *tableData;
}
@synthesize fibitbutton;



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
    tableData = [NSMutableArray arrayWithObjects:@"Fitbit", @"Withing", nil];

    
    // Do any additional setup after loading the view.
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"currUser"];
    [query whereKey:@"device" equalTo:@"all"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            username = [object objectForKey:@"username"];
        } else {
            NSLog(@"The currUser username request failed.");
        }
    }];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 0;
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *appTableIdentifier = @"AppDeviceTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:appTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fibitAction:(id)sender {
    responseData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                             [NSURL URLWithString:@"https://api.samihub.com/v1.1/users/7e95d03d1989482cba5daf625e348906/devices"]];
    [request addValue:@"bearer 9e676ccfc43d4b6b92274816ef38d903" forHTTPHeaderField:@"Authorization"];
    id _ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    #pragma unused(_)
    /*
    // fetch data from Parse
    PFQuery *query = [PFQuery queryWithClassName:fitbitUserInfo];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object == nil) {
            OAuthIOModal *oauthioModal =
            [[OAuthIOModal alloc] initWithKey:OAuthKeyForFitbit delegate:self];
            [oauthioModal showWithProvider:@"fitbit"];
        } else {
            OAuthIOData * data = [[OAuthIOData alloc] init];
            NSString * oauthToken = [object objectForKey:@"oauthToken"];
            [data setOauth_token:oauthToken];
            OAuthIORequest * request = [self getRequestToken:data];
            [self requestFromFitbit:request];
        }
    }];
    */
    //call cloud function
    //    [PFCloud callFunctionInBackground:@"hello"
    //                       withParameters:@{}
    //                                block:^(NSString *result, NSError *error) {
    //                                    if (!error) {
    //                                        self.stepLabel.text = result;
    //                                    }
    //                                }];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"key: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
}

/*
- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request {
    //NSDictionary *credentials = [request getCredentials];
    //NSLog(@"get Token: %@", credentials[@"oauth_token"]);
    //NSLog(@"get Secret: %@", credentials[@"oauth_token_secret"]);
    
    [self putRequestToken:request];
    [self requestFromFitbit:request];
}


- (OAuthIORequest *)getRequestToken:(OAuthIOData *)data {
    OAuthIORequest * request = [[OAuthIORequest alloc] init];
    [request setData:data];
    return request;
}

- (void)putRequestToken:(OAuthIORequest *)request {
    OAuthIOData * data = [request data];
    
    // push request token to Parse
    PFObject *userInfo = [PFObject objectWithClassName:fitbitUserInfo];
    userInfo[@"username"] = username;
    userInfo[@"fitbitFullName"] = @"";
    userInfo[@"fitbitSteps"] = @"";
    userInfo[@"oauthToken"] = [data oauth_token];
    [userInfo saveInBackground];
}

- (void)didFailWithOAuthIOError:(NSError *)error {
    // ignore
    NSLog(@"error: %@", error.description);
}

- (void)requestFromFitbit:(OAuthIORequest *)request {
    [self getUserId];
    [self getUserInfo:request];
    [self getSteps:request];
}

- (void)getUserId {
    PFQuery *query = [PFQuery queryWithClassName:fitbitUserInfo];
    [query whereKey:@"username" equalTo:username];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            userid = object.objectId;
        } else {
            NSLog(@"The currUser userid request failed.");
        }
    }];
}

- (void)getUserInfo:(OAuthIORequest *)request {
    
    [request get:@"https://api.fitbit.com/1/user/-/profile.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         //NSLog(@"status code:%i\n\n", httpResponse.statusCode);
         NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         id fitbitFullName = [json valueForKeyPath:@"user.fullName"];
         NSLog(@"%@", fitbitFullName);
         
         // update fitbitFullName
         PFQuery *query = [PFQuery queryWithClassName:fitbitUserInfo];
         [query getObjectInBackgroundWithId:userid block:^(PFObject *object, NSError *error) {
             object[@"fitbitFullName"] = fitbitFullName;
             [object saveInBackground];
         }];
     }];
}

- (void)getSteps:(OAuthIORequest *)request {
    
    [request get:@"https://api.fitbit.com/1/user/-/activities/date/today.json" success:^(NSDictionary *output, NSString *body, NSHTTPURLResponse *httpResponse)
     {
         //NSLog(@"status code:%i\n\n", httpResponse.statusCode);
         NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         NSString* fitbitSteps = [[json valueForKeyPath:@"summary.steps"] stringValue];
         NSLog(@"%@", fitbitSteps);
         
         // update fitbitSteps
         PFQuery *query = [PFQuery queryWithClassName:fitbitUserInfo];
         [query getObjectInBackgroundWithId:userid block:^(PFObject *object, NSError *error) {
             object[@"fitbitSteps"] = fitbitSteps;
             [object saveInBackground];
         }];
     }];
}
*/

@end
