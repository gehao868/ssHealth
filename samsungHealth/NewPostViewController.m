//
//  NewPostViewController.m
//  samsungHealth
//
//  Created by Trey_L on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import "NewPostViewController.h"
#import "NewsFeedViewController.h"

#import "UserData.h"
#import "Global.h"
#import <Parse/Parse.h>

@interface NewPostViewController ()

@end

@implementation NewPostViewController

UIImage *chosenImage = NULL;

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
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.photoView.hidden = YES;
    chosenImage = NULL;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dismissKeyboard {
    [self.postText endEditing:YES];
    [self.postText resignFirstResponder];
}

- (IBAction)send:(id)sender {
    PFObject *post = [PFObject objectWithClassName:@"News"];
    post[@"content"] = self.postText.text;
    post[@"postusername"] = [UserData getUsername];
    post[@"showlikenum"] = @0;
    post[@"likedby"] = [[NSArray alloc] init];
    post[@"groupname"] = [Global getCurrGroup];
    post[@"type"] = @"text";
    if (chosenImage) {
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        [imageFile saveInBackground];
        post[@"media"] = imageFile;
        post[@"type"] = @"photo";
    }
    
    [post saveInBackground];
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Post Sent" message:@"Succeed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [messageAlert show];
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    }

- (IBAction)choosePhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    }

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    chosenImage = info[UIImagePickerControllerEditedImage];
    UIImageWriteToSavedPhotosAlbum (chosenImage, self, @selector(image:finishedSavingWithError:contextInfo:) , nil);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (chosenImage) {
        self.photo.image = chosenImage;
    }
    self.photoView.hidden = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)
error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image/video"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cancel:(id)sender {
    self.photoView.hidden = YES;
}

- (IBAction)addPhoto:(id)sender {
    if ([self.photoView isHidden]) {
        self.photoView.hidden = NO;
    } else {
        self.photoView.hidden = YES;
    }
}
@end
