//
//  iBGExhPageParentViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/15.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGExhPageParentViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property NSString *callerPage;
@property (strong, nonatomic) NSDictionary *exhInfo;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) NSArray *pageviewContentVCs;
@property (nonatomic, strong) UIPageControl *exhPageControl;
@property (nonatomic, strong) UILabel *navTitleLabel;

@property (strong, nonatomic) IBOutlet UIButton *enterExhBtn;
- (IBAction)clickStartGuide:(id)sender;

@end
