//
//  iBGExhInfoViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/10/28.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGExhPageParentViewController.h"
#import "NYTPhotosViewController.h"
#import "iBGNYTPhoto.h"

@interface iBGExhInfoViewController : UIViewController <NYTPhotosViewControllerDelegate>

@property (strong, nonatomic) iBGExhPageParentViewController *pageParentVC;
@property (strong, nonatomic) NSDictionary *exhInfo;
@property NSString *callerPage;

@property (strong, nonatomic) IBOutlet UINavigationItem *exhNavItem;

@property (strong, nonatomic) IBOutlet UIScrollView *exhScrollView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@property (strong, nonatomic) IBOutlet UILabel *exhDate;
@property (strong, nonatomic) IBOutlet UILabel *exhTime;
@property (strong, nonatomic) IBOutlet UILabel *exhVenue;
@property (strong, nonatomic) IBOutlet UILabel *exhSiteLbl;
@property (strong, nonatomic) IBOutlet UIButton *exhSiteBtn;
@property (strong, nonatomic) IBOutlet UILabel *exhDescription;

@end
