//
//  iBGMoniterViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/10/27.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface iBGMoniterViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIButton *moniterButton;
@property (strong, nonatomic) IBOutlet UIImageView *moniterAnimation;
@property (strong, nonatomic) IBOutlet UILabel *hintLabel;

@property (strong, nonatomic) NSDictionary *objData;
@property (nonatomic) NSInteger exhID;
@property (nonatomic) NSString *exhTitle;
@property (strong, nonatomic) NSDictionary *exhInfo;
@property (nonatomic) NSMutableArray *visitedSec;
@property (nonatomic) NSInteger currentItemID;
@property (nonatomic) NSInteger topicID;
@property (nonatomic) NSArray *topicItems;

- (IBAction)clickExhTest:(id)sender;
- (IBAction)clickItemTest:(id)sender;
- (IBAction)clickSectionTest:(id)sender;
- (IBAction)clickExitTest:(id)sender;

- (void)saveExhCollectData;

@end
