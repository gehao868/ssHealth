//
//  NewPostViewController.h
//  samsungHealth
//
//  Created by Trey_L on 8/12/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NewPostViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;
- (IBAction)send:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *postText;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *recordingMsg;

- (IBAction)takePhoto:(id)sender;
- (IBAction)choosePhoto:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)playandstop:(id)sender;
- (IBAction)startRecording:(id)sender;
- (IBAction)endRecording:(id)sender;
- (IBAction)endRecording1:(id)sender;


@end
