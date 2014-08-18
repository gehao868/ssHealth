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
BOOL chosenAudio = NO;

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
    chosenAudio = NO;
    
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

    [_playButton setHidden:YES];
    [_recordingMsg setHidden:YES];
    
}

- (void)prepareForRecording {
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"audioMsg.m4a",
                               nil];
    
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
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
    if (chosenAudio) {
        NSData *data = [NSData dataWithContentsOfURL:recorder.url];
        PFFile *audioFile = [PFFile fileWithName:@"audioMsg.m4a" data:data];
        [audioFile saveInBackground];
        
        post[@"media"] = audioFile;
        post[@"type"] = @"audio";
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
    self.photo.hidden = NO;
    chosenAudio = NO;
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
        [_playButton setHidden:YES];
    } else {
        self.photoView.hidden = YES;
    }
}

- (IBAction)playandstop:(id)sender {
    if (!player.playing){
        [_playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        
        [player setDelegate:self];
        [player play];
    } else {
        [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        
        [player stop];
    }
}

- (IBAction)startRecording:(id)sender {
    if (player.playing) {
        [player stop];
    }
    
    chosenAudio = YES;
    [self prepareForRecording];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        [recorder record];
        [_recordingMsg setHidden:NO];
    } else {
        [recorder pause];
    }
    
    [_playButton setEnabled:NO];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
}

- (IBAction)endRecording:(id)sender {
    [recorder stop];
    [_recordingMsg setHidden:YES];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (IBAction)endRecording1:(id)sender {
    [recorder stop];
    [_recordingMsg setHidden:YES];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
    [_playButton setEnabled:YES];
    [_playButton setHidden:NO];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    self.photo.hidden = YES;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_playButton setEnabled:YES];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

@end
