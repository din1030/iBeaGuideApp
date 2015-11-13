//
//  iBGTextInputLayer.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/12.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGTextInputLayer.h"

@implementation iBGTextInputLayer

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self setNeedsDisplay];
	}
	return self;
}

- (void)drawInContext:(CGContextRef)ctx {
	self.borderColor = [UIColorFromRGBWithAlpha(0x29ABE2, 1) CGColor];
	self.borderWidth = 0.5;
	self.cornerRadius = 5.0;
}
@end
