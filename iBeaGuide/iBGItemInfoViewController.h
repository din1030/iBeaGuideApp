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
- (IBAction)clickItemMenu:(id)sender;

@end