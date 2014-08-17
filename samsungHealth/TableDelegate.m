//
//  TableDelegate.m
//  HealthCoach
//
//  Created by Jessica Zhuang on 8/13/14.
//  Copyright (c) 2014 Hao Ge. All rights reserved.
//

#define gap 5.0f
#define photoHeight 160.0f

#import "TableDelegate.h"
#import "NewsFeedCell.h"
#import "Global.h"
#import "UserData.h"
#import "News.h"

@implementation TableDelegate 


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[Global getNewsFeed] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIFont *font =  [UIFont systemFontOfSize:14.0f];
    float imgHeight = 47.0f;
    float likesHeight = 38.0f;
    
    News *news = (News *)[[Global getNewsFeed] objectAtIndex:indexPath.row];
    
    NSDictionary *userAttributes = @{NSFontAttributeName:font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize textSize = [news.content sizeWithAttributes:userAttributes];
    
    float newsHeight = ceil((ceil(textSize.width / 300.0f) + 1) * font.lineHeight);
    newsHeight = MAX(newsHeight, 28.0f);
    
    float cellHeight = gap + imgHeight + gap + newsHeight + gap + likesHeight;
    
    if ([news.type isEqualToString:@"photo"]) {
        cellHeight += (photoHeight + gap);
    }
    return cellHeight;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NewsFeedCell";
    
    NewsFeedCell *cell = (NewsFeedCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsFeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *friendAvatars = [UserData getAppFriendAvatars];
    News *news = (News *)[[Global getNewsFeed] objectAtIndex:indexPath.row];

    if ([news.likedby containsObject:[UserData getUsername]]) {
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"heart_filled"] forState:UIControlStateNormal];
        [cell.likeButton setEnabled:NO];
    } else {
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        [cell.likeButton setEnabled:YES];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.newsContent.text = news.content;
    CGRect frame = cell.newsContent.frame;
    
//    NSLog(@"the line number is %f", cell.newsContent.contentSize.height / cell.newsContent.font.lineHeight);
    
    NSDictionary *userAttributes = @{NSFontAttributeName: cell.newsContent.font,
                                     NSForegroundColorAttributeName: [UIColor blackColor]};
    const CGSize textSize = [cell.newsContent.text sizeWithAttributes:userAttributes];
    
//    cell.newsContent.contentSize.height = 28.0f;
    frame.size.height = ceil((ceil(textSize.width / 300.0f) + 1) * cell.newsContent.font.lineHeight);
    if (frame.size.height < 28.0f) {
        frame.size.height = 28.0f;
    }
    cell.newsContent.frame = frame;
   
    cell.likeNum.text = [[news.likenum stringValue] stringByAppendingString:@" likes"];
    cell.userName.text = news.postusername;
    cell.userPic.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[friendAvatars objectForKey:news.postusername]]]];
    
    cell.objid.text = news.objecid;
    
    CGRect likeFrame = cell.likeNum.frame;
//    NSLog(@"like starting point is %f" @" index at %ld", cell.likeNum.frame.origin.y ,(long)indexPath.row);
    likeFrame.origin.y = cell.newsContent.frame.origin.y + cell.newsContent.frame.size.height + gap;
    cell.likeNum.frame = likeFrame;
//    NSLog(@"news height is %f" @" index at %ld", cell.newsContent.frame.size.height, (long)indexPath.row);
//    NSLog(@"news size width %f" @" index at %ld", textSize.width, (long)indexPath.row);
    
    
    CGRect likeImgFrame = cell.likeButton.frame;
    likeImgFrame.origin.y = likeFrame.origin.y;
    cell.likeButton.frame = likeImgFrame;
    
    if ([news.type isEqualToString:@"photo"]) {
        cell.photo.image = [UIImage imageWithData:news.media];
        CGRect photoFrame = cell.photo.frame;
        photoFrame.origin.x = frame.origin.x;
        photoFrame.origin.y = cell.likeButton.frame.origin.y;
        cell.photo.frame = photoFrame;
        
        likeFrame.origin.y = likeFrame.origin.y + photoHeight + gap;
        cell.likeNum.frame = likeFrame;
        
        likeImgFrame.origin.y = likeFrame.origin.y;
        cell.likeButton.frame = likeImgFrame;

    } else {
        cell.photo.hidden = YES;
    }
    NSLog(@"photo starting point is %f" @" index at %ld", cell.photo.frame.origin.y ,(long)indexPath.row);
    NSLog(@"like starting point is %f" @" index at %ld", cell.likeNum.frame.origin.y ,(long)indexPath.row);
    return cell;
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    
}
@end
