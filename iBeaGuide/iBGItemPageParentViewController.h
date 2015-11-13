//
//  iBGItemPageParentViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGItemPageParentViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property NSString *callerPage;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) NSArray *pageviewContentVCs;
@property (strong, nonatomic) IBOutlet UIPageControl *itemPageControl;
@property (strong, nonatomic) IBOutlet UIView *itemPageControlBG;

@property (strong, nonatomic) IBOutlet UIButton *itemMenuBtn;
- (IBAction)clickMenu:(id)sender;


@end
