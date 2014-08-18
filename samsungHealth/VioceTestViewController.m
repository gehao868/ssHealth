////
////  VioceTestViewController.m
////  HealthCoach
////
////  Created by Trey_L on 8/16/14.
////  Copyright (c) 2014 Hao Ge. All rights reserved.
////
//
//#import "VioceTestViewController.h"
//#import <Parse/Parse.h>
//
//@interface VioceTestViewController ()
//
//@end
//
//@implementation VioceTestViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    [_play setEnabled:NO];
//    
//    // Set the audio file
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"audioMsg.m4a",
//                               nil];
//    
//    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
//    
//    // Setup audio session
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    
//    // Define the recorder setting
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//    
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
//    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
//    
//    // Initiate and prepare the recorder
//    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
//    recorder.delegate = self;
//    recorder.meteringEnabled = YES;
//    [recorder prepareToRecord];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//- (IBAction)recordstart:(id)sender {
//    if (player.playing) {
//        [player stop];
//    }
//    
//    if (!recorder.recording) {
//        AVAudioSession *session = [AVAudioSession sharedInstance];
//        [session setActive:YES error:nil];
//        
//        // Start recording
//        [recorder record];
//        [_record setTitle:@"Pause" forState:UIControlStateNormal];
//        
//    } else {
//        
//        // Pause recording
//        [recorder pause];
//        [_record setTitle:@"Record" forState:UIControlStateNormal];
//    }
//    
//    [_play setEnabled:NO];
//}
//
//- (IBAction)recorddone:(id)sender {
//    [recorder stop];
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    [audioSession setActive:NO error:nil];
//}
//
//- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
//    [_record setTitle:@"Record" forState:UIControlStateNormal];
//    [_play setEnabled:YES];
//    
//    // save audio to background
//    NSData *data = [NSData dataWithContentsOfURL:recorder.url];
//    PFFile *file = [PFFile fileWithName:@"audioMsg.m4a" data:data];
//    [file saveInBackground];
//    
//    PFObject *audio = [PFObject objectWithClassName:@"audio"];
//    audio[@"content"] = file;
//    [audio saveInBackground];
//}
//
//- (IBAction)playact:(id)sender {
//    PFQuery *query = [PFQuery queryWithClassName:@"audio"];
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *result, NSError *error) {
//        PFFile *audio = [result objectForKey:@"content"];
//        NSData *data = [audio getData];
//        
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
//        player = [[AVAudioPlayer alloc] initWithData:data error:nil];
//        [player setDelegate:self];
//        [player play];
//    }];
//    
//    /*
//    if (!recorder.recording){
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
//        [player setDelegate:self];
//        [player play];
//    }
//     */
//}
//
//- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
//                                                    message: @"Finish playing the recording!"
//                                                   delegate: nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//}
//
//@end
