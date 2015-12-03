//
//  iBGMoniterViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/10/27.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGMoniterViewController.h"

#define kWebAPIRoot @"http://114.34.1.57/iBeaGuide/App"
#define kBeaconIdentifier @"iBeaGuide"

@interface iBGMoniterViewController ()

@end

@implementation iBGMoniterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.visitedSec = [[NSMutableArray alloc] init];
	
	// 設定偵測動畫
	NSMutableArray *animationImg = [NSMutableArray arrayWithObjects:
									[UIImage imageNamed:@"detect_1.png"],
									[UIImage imageNamed:@"detect_2.png"],
									[UIImage imageNamed:@"detect_3.png"], nil];
	[self.moniterAnimation setAnimationImages: animationImg];
	[self.moniterAnimation setAnimationDuration: 1.5];
	//    [self.moniterAnimation setAnimationRepeatCount:20];
	[self.moniterAnimation startAnimating];
	
	
	// 設定 tab bar 圖案
	UIImage *moniterImg = [[UIImage imageNamed:@"guide_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *moniterSelectedImg = [[UIImage imageNamed:@"guide_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *collectImg = [[UIImage imageNamed:@"collection_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *collectSelectedImg = [[UIImage imageNamed:@"collection_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *settingImg = [[UIImage imageNamed:@"setting_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *settingSelectedImg = [[UIImage imageNamed:@"setting_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	
	UITabBar *tabBar = self.tabBarController.tabBar;
	
	UITabBarItem *moniterItem = [tabBar.items objectAtIndex:0];
	UITabBarItem *collectItem = [tabBar.items objectAtIndex:1];
	UITabBarItem *settingItem = [tabBar.items objectAtIndex:2];
	
	[moniterItem setImage:moniterImg];
	[moniterItem setSelectedImage:moniterSelectedImg];
	[collectItem setImage:collectImg];
	[collectItem setSelectedImage:collectSelectedImg];
	[settingItem setImage:settingImg];
	[settingItem setSelectedImage:settingSelectedImg];
	
	moniterItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0);
	collectItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0);
	settingItem.imageInsets = UIEdgeInsetsMake(5.5, 0, -5.5, 0);
	
	// Initialize location manager and set ourselves as the delegate
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.delegate = self;
	
	// 要定位權限
	if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
		[self.locationManager requestAlwaysAuthorization];
	}
	
	// Set up Beacon UUID and region
	NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
	self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: beaconUUID
																  major: 23235
																  minor: 64899
															 identifier: kBeaconIdentifier];
	
	// Tell location manager to start monitoring for the beacon region
	[self.locationManager startMonitoringForRegion:self.myBeaconRegion];
	//	[self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
	//	[self.locationManager startUpdatingLocation];
	
	// testing data
	self.exhID = 1;
//	self.routeID = 1;
//	self.routeItems = @[@17];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - location

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
	[self.locationManager startUpdatingLocation];
	
	// get obj data linked to the region
	[self getBeaconLinkedObjByRegion:region];
	
	//	[manager startRangingBeaconsInRegion:beaconRegion];
	
}


-(BOOL)getBeaconLinkedObjByRegion:(CLRegion *)region{
	
	// get ibeacon link obj info via url
	CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
	NSString *urlString = [NSString stringWithFormat:@"%@/get_iBeacon_link_obj/%@/%@/%@", kWebAPIRoot, beaconRegion.proximityUUID.UUIDString, beaconRegion.major, beaconRegion.minor];
	NSURL *url = [NSURL URLWithString: urlString];
	NSError *dataError, *jsonError;
	NSData *data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&dataError];
	NSLog(@"URL: %@", urlString);
	if (dataError) {
		NSLog(@"dataError: %@",[dataError localizedDescription]);
		return NO;
	}
	
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
	if (jsonError) {
		NSLog(@"jsonError: %@",[jsonError localizedDescription]);
		return NO;
	}
	
	// if no data then return NO
	if (result == NULL || [result count] == 0) {
		NSLog(@"%@", @"偵測到未連結物件之 ibeacon");
		return NO;
	}
	
	// 有資料
	NSString *objType = [result objectForKey:@"type"];
	self.objData = [result objectForKey:@"data"] ;
	NSInteger objID = [[self.objData objectForKey:@"id"] integerValue];
	NSString *objTitle = [self.objData objectForKey:@"title"];
	
	NSLog(@"取得資料類型： %@", objType);
	NSLog(@"資料ID/標題： %@/%@", @(objID), objTitle);
	
	// 判斷物件類型，展覽跳出 alert
	if ([objType isEqualToString:@"exh"]) {
		
//		self.exhID = [[self.objData objectForKey:@"id"] integerValue];
		
		// 如果 app 在背景用推播通知 user
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
			[self sendLocalNotificationWithMessage:[NSString stringWithFormat:@"%@", [self.objData objectForKey:@"push_content"]]];
		}
		// Show alert with action btns
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"哈囉～"
																				 message:[NSString stringWithFormat:@"偵測到「%@」展覽資訊，是否開始導覽？", objTitle]
																		  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"開始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self performSegueWithIdentifier: @"MoniterExh" sender: self];
		}];
		[alertController addAction:cancelAction];
		[alertController addAction:okAction];
		
		alertController.view.backgroundColor = UIColorFromRGBWithAlpha(0xF9F7F3, 1);
		alertController.view.tintColor = UIColorFromRGBWithAlpha(0x29ABE2, 1);
		alertController.view.layer.cornerRadius = 5;
		
		[self presentViewController:alertController animated:YES completion:nil];
		
		// 若類型為展品，屬於當前展覽才需顯示
	} else if ([objType isEqualToString:@"item"] && [[self.objData objectForKey:@"exh_id"] integerValue] == self.exhID) {
		

        // 如果 app 在背景用推播通知 user
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            [self sendLocalNotificationWithMessage:[NSString stringWithFormat:@"%@", [self.objData objectForKey:@"push_content"]]];
        }
		
		NSLog(@"展品 %@ 屬於展覽 %@", @(objID), @(self.exhID));
		
		// 未選擇路線 || 有選擇路線且屬於當前路線
		if (self.routeID == 0 || (self.routeID != 0 && [self.routeItems count] > 0 && [self.routeItems containsObject:@(objID)])) {
			
			NSLog(@"展品 %@ 在路線 %@ 中", @(objID), @(self.routeID));
			id sec_id = [self.objData objectForKey:@"sec_id"];
			NSInteger secID = ([sec_id isEqual:[NSNull null]]) ? 0 : [sec_id integerValue];
			// 沒有設定展區直接前往展品頁面
			if (secID == 0 || [self.visitedSec containsObject:@(secID)]) {
				
				NSLog(@"展品未設定展區或已顯示過展區資訊");
				[self performSegueWithIdentifier:@"MoniterItem" sender:self];
				
				// 展區編號存在則前往展區頁面
			} else {
				
				NSLog(@"展品 %@ 屬於展區 %@", @(objID), @(secID));
				[self.visitedSec addObject:@(secID)];
				[self performSegueWithIdentifier:@"MoniterSec" sender:self];
				
			}
			
		}
		
	}
	
	return YES;
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
	// Exited the region
	[self.locationManager stopRangingBeaconsInRegion:self.myBeaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager
	   didRangeBeacons:(NSArray *)beacons
			  inRegion:(CLBeaconRegion *)region
{
	
	//	CLBeacon *foundBeacon = [beacons firstObject];
	
	// You can retrieve the beacon data from its properties
	// NSString *uuid = foundBeacon.proximityUUID.UUIDString;
	// NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
	// NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
	//	NSLog(@"major %@", major);
	
}


-(void)sendLocalNotificationWithMessage:(NSString *)message {
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.alertBody = message;
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	NSLog(@"exhID: %ld", (long)self.exhID);
	NSLog(@"routeID: %ld", (long)self.routeID);
}

#pragma mark - Testing Btn Click Action Methods

- (IBAction)clickExhTest:(id)sender {
	
	NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
	CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:1560 minor:3897 identifier:kBeaconIdentifier];
	// get obj data linked to the region
	[self getBeaconLinkedObjByRegion:region];
}

- (IBAction)clickItemTest:(id)sender {
	
	NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
	CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:29122 minor:24107 identifier:kBeaconIdentifier];
	[self getBeaconLinkedObjByRegion:region];
	//	[self performSegueWithIdentifier:@"MoniterItem" sender:self];
	
}

- (IBAction)clickSectionTest:(id)sender {
	
	[self performSegueWithIdentifier:@"MoniterSec" sender:self];
	
}

- (IBAction)clickExitTest:(id)sender {
	
	[self performSegueWithIdentifier:@"MoniterExit" sender:self];
	
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	
	// 抓到展覽訊號去展覽資訊頁面
	if ([segue.identifier isEqualToString:@"MoniterExh"]) {
		NSLog(@"Go exhID: %ld", (long)self.exhID);
		[[segue destinationViewController] setValue:self.objData forKey:@"exhInfo"];
	
	}
	
	// 出口訊號去出口頁面
	else if ([segue.identifier isEqualToString:@"MoniterExit"]) {
		NSLog(@"Exit for : %ld", (long)self.exhID);
		[[segue destinationViewController] setValue:self.exhInfo forKey:@"exhInfo"];
	}
	
	// 抓到有展區的展品訊號去展區資訊頁面
	else if ([segue.identifier isEqualToString:@"MoniterSec"]) {
		NSLog(@"Go routeID: %ld, secID: %@", (long)self.routeID, [self.objData objectForKey:@"sec_id"]);
		[[segue destinationViewController] setValue:self.objData forKey:@"prepareItemInfo"];	}
	
	// 抓到沒有展區的展品訊號去展品資訊頁面
	else if ([segue.identifier isEqualToString:@"MoniterItem"]) {
		NSLog(@"Go itemID: %@", [self.objData objectForKey:@"id"]);
		[segue destinationViewController].navigationItem.title = self.exhTitle;
		[[segue destinationViewController] setValue:self.objData forKey:@"itemInfo"];
	}
	
}

@end
