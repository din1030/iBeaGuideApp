//
//  iBGMyCollectionTableViewHeaderCell.h
//  iBeaGuide
//
//  Created by din1030 on 2015/12/8.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface iBGMyCollectionTableViewHeaderCell : UITableViewCell

//@property NSManagedObject *exhManagedObj;
@property NSDictionary *exhInfo;
@property (strong, nonatomic) IBOutlet UIImageView *exhPic;
@property (strong, nonatomic) IBOutlet UILabel *exhTitle;

@end
