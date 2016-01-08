//
//  iBGSectionInfoViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/15.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYTPhotosViewController.h"

#import "iBGNYTPhoto.h"

@interface iBGSectionInfoViewController : UIViewController <NYTPhotosViewControllerDelegate>

@property (strong, nonatomic) NSDictionary *prepareItemInfo;

@property NYTPhotosViewController *photosViewController;
@property NSMutableArray *secPicArray;
@property (nonatomic) NSArray *photos;

@property (strong, nonatomic) IBOutlet UIScrollView *secInfoScrollView;
@property (strong, nonatomic) IBOutlet UILabel *secTitle;
@property (strong, nonatomic) IBOutlet UIButton *secPicBtn;
@property (strong, nonatomic) IBOutlet UIImageView *secPic;

@property (strong, nonatomic) IBOutlet UILabel *secDes;
@property (strong, nonatomic) IBOutlet UIButton *secEnterBtn;
@property (strong, nonatomic) IBOutlet UILabel *countDownLabel;
@property NSTimer *countDownTimer;
@end
