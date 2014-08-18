//
//  NewsFeedCell.h
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface NewsFeedCell : UITableViewCell <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
}

@property (strong, nonatomic) IBOutlet UITextView *newsContent;
@property (strong, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *objid;

- (IBAction)liked:(id)sender;
- (IBAction)playAudio:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) NSData *data;

@end
