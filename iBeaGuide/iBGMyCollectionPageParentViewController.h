//
//  iBGMyCollectionPageParentViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/8.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGMyCollectionPageParentViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;

@property (strong, nonatomic) UIPageViewController *collectionPageViewController;
@property (strong, nonatomic) IBOutlet UIPageControl *collectionPageControl;
@property (strong, nonatomic) IBOutlet UIView *collectionPageControlBG;
@property (nonatomic) NSArray *exhInMyCollection;

@end
