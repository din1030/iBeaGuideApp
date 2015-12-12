//
//  iBGItemInfoViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGItemPageParentViewController.h"
#import "NYTPhotosViewController.h"
#import "iBGNYTPhoto.h"

@interface iBGItemInfoViewController : UIViewController <NYTPhotosViewControllerDelegate>

@property NSString *callerPage;

@property NYTPhotosViewController *photosViewController;
@property NSMutableArray *itemPicArray;
@property (nonatomic) NSArray *photos;
@property NSDictionary *itemInfo;

@property (strong, nonatomic) IBOutlet UIScrollView *itemInfoScrollView;

@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemSubtitle;

@property (strong, nonatomic) IBOutlet UIButton *itemInfoPicBtn;

@property (strong, nonatomic) IBOutlet UILabel *itemCreator;
@property (strong, nonatomic) IBOutlet UILabel *itemFinishedTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *itemFinishedTimeValue;
@property (strong, nonatomic) IBOutlet UILabel *fieldName1;
@property (strong, nonatomic) IBOutlet UILabel *fieldValue1;
@property (strong, nonatomic) IBOutlet UILabel *fieldName2;
@property (strong, nonatomic) IBOutlet UILabel *fieldValue2;
@property (strong, nonatomic) IBOutlet UILabel *fieldName3;
@property (strong, nonatomic) IBOutlet UILabel *fieldValue3;
@property (strong, nonatomic) IBOutlet UILabel *itemBrief;

@end
