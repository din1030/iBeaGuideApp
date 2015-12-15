//
//  iBGCommentTableViewCell.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/15.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGCommentTableViewCell.h"
#import "UILabel+AutoHeight.h"

@implementation iBGCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
	[super awakeFromNib];
	self.starArr = @[self.star1, self.star2, self.star3, self.star4, self.star5];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	NSLog(@"self.rate = %@", self.rate);
	for (int i = 0; i < self.rate.intValue; i++) {
		[self.starArr[i] setImage:[UIImage imageNamed:@"star_on.png"]];
	}

}

- (CGSize)sizeThatFits:(CGSize)size {

	CGRect contentRect = CGRectZero;
	contentRect = CGRectUnion(contentRect, self.username.frame);
	contentRect = CGRectUnion(contentRect, self.commentContent.frame);
	
	return CGSizeMake(size.width, contentRect.size.height + 8);
}

@end
