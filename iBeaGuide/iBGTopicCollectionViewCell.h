//
//  iBGTopicCollectionViewCell.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/14.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGTopicCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *topicTitle;
@property (strong, nonatomic) IBOutlet UIImageView *topicMainPic;
@property (strong, nonatomic) IBOutlet UITextView *topicDescription;
@property (strong, nonatomic) IBOutlet UIButton *topicCheckBtn;

@property NSInteger topicID;

@end
