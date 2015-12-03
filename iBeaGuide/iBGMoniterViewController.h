//
//  iBGMoniterViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/10/27.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#define UIColorFromRGBWithAlpha(rgbValue, a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
				green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
				 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
				alpha:a]

@interface iBGMoniterViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIButton *moniterButton;
@property (strong, nonatomic) IBOutlet UIImageView *moniterAnimation;

@property (strong, nonatomic) NSDictionary *objData;
@property (nonatomic) NSInteger exhID;
@property (nonatomic) NSString *exhTitle;
@property (strong, nonatomic) NSDictionary *exhInfo;
@property (nonatomic) NSMutableArray *visitedSec;
@property (nonatomic) NSInteger routeID;
@property (nonatomic) NSArray *routeItems;

- (IBAction)clickExhTest:(id)sender;
- (IBAction)clickItemTest:(id)sender;
- (IBAction)clickSectionTest:(id)sender;
- (IBAction)clickExitTest:(id)sender;

@end
