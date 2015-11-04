//
//  iBGExhInfoViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/10/28.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGExhInfoViewController : UIViewController

@property (strong, nonatomic) NSDictionary *exhInfo;

@property (strong, nonatomic) IBOutlet UINavigationItem *exhNavItem;

@property (strong, nonatomic) IBOutlet UIScrollView *exhScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *exhMainImg;

@property (strong, nonatomic) IBOutlet UILabel *exhDate;
@property (strong, nonatomic) IBOutlet UILabel *exhTime;
@property (strong, nonatomic) IBOutlet UILabel *exhVenue;
@property (strong, nonatomic) IBOutlet UITextView *exhSite;
@property (strong, nonatomic) IBOutlet UITextView *exhDescription;

@property (strong, nonatomic) IBOutlet UIButton *enterExhBtn;

- (IBAction)clickStartGuide:(id)sender;

@end
