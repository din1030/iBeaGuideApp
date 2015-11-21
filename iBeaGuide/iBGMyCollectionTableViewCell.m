//
//  iBGMyCollectionTableViewCell.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/17.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGMyCollectionTableViewCell.h"

@implementation iBGMyCollectionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	for (UIView *subview in self.contentView.superview.subviews) {
		if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
			subview.hidden = NO;
		}
	}
}

@end
