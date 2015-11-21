//
//  iBGItemInfoViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGItemPageParentViewController.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
//#import <NYTPhotoViewer/NYTPhotoViewController.h>
#import "iBGNYTPhoto.h"

@interface iBGItemInfoViewController : UIViewController <NYTPhotosViewControllerDelegate>

@property NYTPhotosViewController *photosViewController;
@property NSMutableArray *itemPicArray;
@property (nonatomic) NSArray *photos;

@property (strong, nonatomic) IBOutlet UIScrollView *itemInfoScrollView;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;
@property (strong, nonatomic) IBOutlet UILabel *itemSubtitle;

@property (strong, nonatomic) IBOutlet UIButton *itemInfoPicBtn;

//@property (strong, nonatomic) IBOutlet UITextView *itemBrief123;
@property (strong, nonatomic) IBOutlet UILabel *itemCreator;

@property (strong, nonatomic) IBOutlet UILabel *itemBrief;



@end
