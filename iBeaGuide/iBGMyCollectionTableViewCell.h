//
//  iBGMyCollectionTableViewCell.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/17.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGMyCollectionTableViewCell : UITableViewCell

@property NSDictionary *itemInfo;
@property (strong, nonatomic) IBOutlet UILabel *itemTitle;

@end
