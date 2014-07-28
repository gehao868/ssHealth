//
//  AppsDevicesViewController.h
//  Health360
//
//  Created by Hao Ge on 7/21/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppsDevicesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *fibitbutton;

- (IBAction)fibitAction:(id)sender;
/*
// Handles the results of a successful authentication
- (void)didReceiveOAuthIOResponse:(OAuthIORequest *)request;

// Handle errors in the case of an unsuccessful authentication
- (void)didFailWithOAuthIOError:(NSError *)error;

- (OAuthIORequest *)getRequestToken:(OAuthIOData *)data;

- (void)putRequestToken:(OAuthIORequest *)request;

- (void)requestFromFitbit:(OAuthIORequest *)request;

- (void)getUserId;

- (void)getUserInfo:(OAuthIORequest *)request;

- (void)getSteps:(OAuthIORequest *)request;
*/

@end
