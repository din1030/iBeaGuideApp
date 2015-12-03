//
//  iBGNYTPhoto.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/6.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYTPhoto.h"

@interface iBGNYTPhoto : NSObject <NYTPhoto>

// Redeclare all the properties as readwrite for sample/testing purposes.
@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;

@end
