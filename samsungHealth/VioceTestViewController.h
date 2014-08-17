//
//  VioceTestViewController.h
//  HealthCoach
//
//  Created by Trey_L on 8/16/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VioceTestViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@property (strong, nonatomic) IBOutlet UIButton *record;
@property (strong, nonatomic) IBOutlet UIButton *play;

- (IBAction)recordstart:(id)sender;
- (IBAction)recorddone:(id)sender;
- (IBAction)playact:(id)sender;

@end
