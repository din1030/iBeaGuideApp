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
//	[self.commentContent autoHeight];
	
//	self.commentContent.translatesAutoresizingMaskIntoConstraints = NO;

//	NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.commentContent attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:25];
//	NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.commentContent attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-25];
//	NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.commentContent attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:63];
//	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.commentContent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-9];
//	
//	[self addConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
}

- (CGSize)sizeThatFits:(CGSize)size {
	
//	[self.commentContent autoHeight];
	
	// 取scrollview 所有 subview 的 frame 的聯集
	CGRect contentRect = CGRectZero;
//	for (UIView *view in self.subviews) {
//		contentRect = CGRectUnion(contentRect, view.frame);
//	}
	//
	contentRect = CGRectUnion(contentRect, self.username.frame);
	contentRect = CGRectUnion(contentRect, self.commentContent.frame);
	
	return CGSizeMake(size.width, contentRect.size.height + 8);
}

@end
