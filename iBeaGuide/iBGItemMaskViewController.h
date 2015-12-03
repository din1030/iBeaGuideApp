//
//  iBGItemMaskViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/4.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGItemMaskViewController : UIViewController

@property (strong, nonatomic) NSDictionary *itemInfo;

@property (strong, nonatomic) IBOutlet UIView *itemMaskView;
@property (strong, nonatomic) IBOutlet UIButton *msgBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapMaskView;
- (IBAction)clickMenuOptionBtn:(id)sender;

@end
