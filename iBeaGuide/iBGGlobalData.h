//
//  iBGGlobalData.h
//  iBeaGuide
//
//  Created by din1030 on 2015/12/13.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface iBGGlobalData : NSObject

@interface iBGGlobalData : NSObject

@property BOOL facilityPushIsOn;
@property BOOL autoPlayIsOn;

+ (iBGGlobalData *)sharedInstance;

@end


