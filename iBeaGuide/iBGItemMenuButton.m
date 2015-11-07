//
//  iBGItemMenuButton.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/4.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemMenuButton.h"

@implementation iBGItemMenuButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
	
	self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(1.0f,3.0f);
	self.layer.masksToBounds = NO;
	self.layer.shadowRadius = 2.5f;
	self.layer.shadowOpacity = 0.8;

}

@end
