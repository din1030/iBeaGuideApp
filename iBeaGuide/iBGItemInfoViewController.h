//
//  iBGItemInfoViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGItemPageParentViewController.h"

@interface iBGItemInfoViewController : UIViewController

@property (strong, nonatomic) iBGItemPageParentViewController *pageParentVC;

@property (strong, nonatomic) IBOutlet UIScrollView *itemInfoScrollView;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemSubtitle;
@property (strong, nonatomic) IBOutlet UIImageView *itemMainPic;
//@property (strong, nonatomic) IBOutlet UITextView *itemBrief123;
@property (strong, nonatomic) IBOutlet UILabel *itemCreator;

@property (strong, nonatomic) IBOutlet UILabel *itemBrief;


@end
