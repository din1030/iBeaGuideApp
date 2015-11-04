//
//  iBGItemPageViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGItemPageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) NSArray *pageviewContentVCs;
@property (strong, nonatomic) IBOutlet UIPageControl *itemPageControl;
@property (strong, nonatomic) IBOutlet UIPageControl *itemPageControlBG;

@end
