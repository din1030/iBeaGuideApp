//
//  UILabel+AutoHeight.m
//  iBeaGuide
//
//  Created by din1030 on 2015/12/1.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "UILabel+AutoHeight.h"

@implementation UILabel (AutoHeight)

- (void)autoHeight {
    
    CGRect txtFrame = self.frame;
    txtFrame.size.height = [self.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                             options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil] context:nil].size.height;
    self.frame = txtFrame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
