//
//  iBGCommentTableViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/6.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGItemPageParentViewController.h"
#import "iBGExhPageParentViewController.h"

@interface iBGCommentTableViewController : UITableViewController


@property NSString *commentType;
@property NSString *commentObjID;

@property (strong, nonatomic) iBGItemPageParentViewController *itemPageParentVC;
@property (strong, nonatomic) iBGExhPageParentViewController *exhPageParentVC;

@property NSString *commentObjTitle;
@property NSString *commentObjSubtitle;

@property (nonatomic) NSArray *commentArray;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
