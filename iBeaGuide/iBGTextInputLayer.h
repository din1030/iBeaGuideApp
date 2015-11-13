//
//  iBGTextInputLayer.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/12.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#define UIColorFromRGBWithAlpha(rgbValue, a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
				green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
				 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
				alpha:a]

@interface iBGTextInputLayer : CALayer

//@property (nonatomic, assign) CGFloat   radius;
//@property  CGFloat borderWidth;
//@property (nonatomic, assign) CGFloat   cornerRadius;

@end
