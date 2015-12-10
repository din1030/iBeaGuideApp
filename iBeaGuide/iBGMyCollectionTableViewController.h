//
//  iBGMyCollectionTableViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/7.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGMyCollectionPageParentViewController.h"

@interface iBGMyCollectionTableViewController : UITableViewController

@property (strong, nonatomic) iBGMyCollectionPageParentViewController *collectPageParentVC;

@property NSUInteger pageIndex;
//@property (nonatomic) NSManagedObject *exhData;
@property (nonatomic) NSDictionary *exhInfo;
@property (nonatomic) NSArray *itemList;

@end
