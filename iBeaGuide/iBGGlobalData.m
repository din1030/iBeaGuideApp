//
//  iBGGlobalData.m
//  iBeaGuide
//
//  Created by din1030 on 2015/12/13.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGGlobalData.h"

@implementation iBGGlobalData

+ (iBGGlobalData *)sharedInstance {
	
	static iBGGlobalData *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[iBGGlobalData alloc] init];
	});
	
	return sharedInstance;
}

- (id)init {
	
	if (self = [super init]) {
		self.autoPlayIsOn = YES;
		self.facilityPushIsOn = YES;
		self.loggedUserID = @1;
	}
	
	return self;
}

@end
