//
//  iBGRouteCollectionViewCell.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/14.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGRouteCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *routeTitle;
@property (strong, nonatomic) IBOutlet UIImageView *routeMainPic;
@property (strong, nonatomic) IBOutlet UITextView *routeDescription;
@property (strong, nonatomic) IBOutlet UIButton *routeCheckBtn;

@property NSInteger routeID;

@end
