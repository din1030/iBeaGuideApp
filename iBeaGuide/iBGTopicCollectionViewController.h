//
//  iBGTopicCollectionViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/14.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGTextInputLayer.h"
#import "iBGTopicCollectionViewCell.h"

@interface iBGTopicCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *topicCollectionView;
@property (nonatomic) NSArray *topicList;

@end
