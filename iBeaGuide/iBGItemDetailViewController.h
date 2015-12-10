//
//  iBGItemDetailViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGItemPageParentViewController.h"
#import "NYTPhotosViewController.h"
#import "iBGNYTPhoto.h"

@interface iBGItemDetailViewController : UIViewController<NYTPhotosViewControllerDelegate>

@property NSString *callerPage;
@property NYTPhotosViewController *photosViewController;
@property (nonatomic) NSArray *photos;
@property NSMutableArray *itemPicArray;
@property NSDictionary *itemInfo;

@property (strong, nonatomic) IBOutlet UIScrollView *itemDetailScrollView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

// item info ui outlets
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemSubtitle;

@property (strong, nonatomic) IBOutlet UILabel *detailFieldName1;
@property (strong, nonatomic) IBOutlet UILabel *detailFieldValue1;
@property (strong, nonatomic) IBOutlet UILabel *detailFieldName2;
@property (strong, nonatomic) IBOutlet UILabel *detailFieldValue2;
@property (strong, nonatomic) IBOutlet UILabel *detailFieldName3;
@property (strong, nonatomic) IBOutlet UILabel *detailFieldValue3;
@property (strong, nonatomic) IBOutlet UILabel *itemDetail;



@end
