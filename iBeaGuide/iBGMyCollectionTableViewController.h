//
//  iBGMyCollectionTableViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/7.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGCollectionPageParentViewController.h"

@interface iBGMyCollectionTableViewController : UITableViewController

@property (strong, nonatomic) iBGCollectionPageParentViewController *collectPageParentVC;

@property NSUInteger pageIndex;
@property (nonatomic) NSArray *itemData;

@end
