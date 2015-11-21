//
//  iBGCommentTableViewCell.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/15.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGCommentTableViewCell.h"

@implementation iBGCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
	
	self.starArr = @[self.star1, self.star2, self.star3, self.star4, self.star5];
	
	self.rate = 3;
	for (int i = 1; i < self.rate ; i++) {
		[self.starArr[i] setImage:[UIImage imageNamed:@"star_on.png"]];
	}
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
