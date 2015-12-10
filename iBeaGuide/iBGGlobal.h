//
//  iBGGlobal.h
//  iBeaGuide
//
//  Created by din1030 on 2015/12/8.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#ifndef iBGGlobal_h
#define iBGGlobal_h

#define UIColorFromRGBWithAlpha(rgbValue, a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
				green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
				 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
				alpha:a]

#endif /* iBGGlobal_h */
