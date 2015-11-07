//
//  iBGItemCommentTableViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/6.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGItemPageParentViewController.h"

@interface iBGItemCommentTableViewController : UITableViewController

@property (strong, nonatomic) iBGItemPageParentViewController *pageParentVC;
@property (nonatomic) NSMutableArray *commentsOfItem;

@end
