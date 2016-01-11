//
//  iBGMoniterViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/10/27.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "AppDelegate.h"
#import "iBGGlobal.h"
#import "iBGGlobalData.h"
#import "iBGMoniterViewController.h"
#import "UIView+Glow.h"
#import "MBProgressHUD.h"
 #import <CoreBluetooth/CoreBluetooth.h>

#define kWebAPIRoot @"http://114.34.1.57/iBeaGuide/App"
//#define kBeaconIdentifier @"iBeaGuide"
#define kBeaconIdentifier(i) \
[NSString stringWithFormat:@"iBeaGuide%d", i]

@interface iBGMoniterViewController () <CBCentralManagerDelegate>

@property NSManagedObjectContext *context;
@property NSManagedObject *exhManegedObj;
@property CLBeacon *nowBeacon;
@property CBCentralManager *centralManager;

@end

@implementation iBGMoniterViewController

- (void)viewDidLoad {

	[super viewDidLoad];
	
	self.nowBeacon = [CLBeacon alloc];
	self.exhID = -1;
	self.currentItemID = -1;
	self.topicID = -1;
	self.visitedSec = [[NSMutableArray alloc] init];
	
	// 設定偵測動畫
	NSMutableArray *animationImg = [NSMutableArray arrayWithObjects:
									[UIImage imageNamed:@"logo.png"],
									[UIImage imageNamed:@"logo_1.png"],
									[UIImage imageNamed:@"logo_2.png"],
									[UIImage imageNamed:@"logo_1.png"], nil];

	[self.moniterAnimation setAnimationImages: animationImg];
	[self.moniterAnimation setAnimationDuration: 2.0];
	[self.moniterAnimation startAnimating];
	
	[self.hintLabel startGlowing];
	
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
	
	/*
	int i = 1;
	for (NSDictionary *iBeacon in [self getiBeacons]) {
		NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: [iBeacon objectForKey:@"uuid"]];
		CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:[[iBeacon objectForKey:@"major"] integerValue] minor:[[iBeacon objectForKey:@"minor"] integerValue] identifier:kBeaconIdentifier(i++)];
		[self.locationManager startMonitoringForRegion:region];
	}
	NSLog(@"Regions monitering: %d", --i);
	*/
	
	// Set up Beacon UUID and region
	NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
	self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:kBeaconIdentifier(1)];
//
//	NSMutableArray *regionArr = [[NSMutableArray alloc] initWithObjects:self.myBeaconRegion, nil];
//	NSMutableArray *regionArr = [[NSMutableArray alloc] init];
	
//	NSUUID *SPOTbeaconUUID = [[NSUUID alloc] initWithUUIDString: @"D3556E50-C856-11E3-8408-0221A885EF40"];
//	[regionArr addObject:[[CLBeaconRegion alloc] initWithProximityUUID:SPOTbeaconUUID identifier:kBeaconIdentifier(2)]];
//
//	NSLog(@"Regions monitering: %ld", [regionArr count]);
	
	// Tell location manager to start monitoring for the beacon region
//	for (CLBeaconRegion *region in regionArr) {
		[self.locationManager startMonitoringForRegion:self.myBeaconRegion];
		[self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
//	}
	
	//	[self.locationManager startRangingBeaconsInRegion:self.myBeaconRegion];
		[self.locationManager startUpdatingLocation];
	
}
- (void)viewDidAppear:(BOOL)animated {
	
	self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
	
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	NSLog(@"exhID: %ld", (long)self.exhID);
	NSLog(@"topicID: %ld", (long)self.topicID);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
	if (central.state == CBCentralManagerStatePoweredOn) {
		//Do what you intend to do
	} else if(central.state == CBCentralManagerStatePoweredOff) {
		//Bluetooth is disabled. ios pops-up an alert automatically
	}
}

- (NSArray *)getiBeacons {
	
	NSString *urlString = [NSString stringWithFormat:@"%@/get_ibeacons/", kWebAPIRoot];
	NSURL *url = [NSURL URLWithString: urlString];
	NSError *dataError, *jsonError;
	NSData *data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&dataError];
	NSLog(@"URL: %@", urlString);
	if (dataError) {
		NSLog(@"dataError: \n UserInfo => %@ \n Description => %@",[dataError userInfo], [dataError localizedDescription]);
		return nil;
	}
	
	NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
	if (jsonError) {
		NSLog(@"jsonError: \n UserInfo => %@ \n Description => %@",[jsonError userInfo], [jsonError localizedDescription]);
		return nil;
	}
	
	return result;
}

- (void)saveExhCollectData {
	
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	self.context = [appDelegate managedObjectContext];
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exhibition"];
	[request setPredicate:[NSPredicate predicateWithFormat:@"id = %@", [self.exhInfo valueForKey:@"id"]]];
	[request setFetchLimit:1];
	
	NSError *fetchError;
	NSUInteger count = [self.context countForFetchRequest:request error:&fetchError];
	if (count > 0) {
		NSLog(@"展覽已在使用者收藏中。");
		return;
	} else if (count == NSNotFound) {
		if (fetchError) {
			NSLog(@"fetchError: \n UserInfo => %@ \n Description => %@",[fetchError userInfo], [fetchError localizedDescription]);
		}
	}
		
	// 建立一個要 insert 的物件
	NSEntityDescription *exhEntity = [NSEntityDescription entityForName:@"Exhibition" inManagedObjectContext:self.context];
	self.exhManegedObj = [[NSManagedObject alloc] initWithEntity:exhEntity insertIntoManagedObjectContext:self.context];
	
	for (NSString *key in [[exhEntity attributesByName] allKeys]) {
		if ([[self.exhInfo allKeys] containsObject:key]) {
			if ([[exhEntity attributesByName] objectForKey:key].attributeType == NSInteger16AttributeType) {
				[self.exhManegedObj setValue:@([[self.exhInfo objectForKey:key] intValue]) forKey:key];
			} else {
				[self.exhManegedObj setValue:[self.exhInfo objectForKey:key] forKey:key];
			}
			NSLog (@"%@ => %@", key, [self.exhManegedObj valueForKey:key]);
		}
	}
	
	[self.exhManegedObj setValue:[self.exhInfo objectForKey:@"description"] forKey:@"exhDescripition"];
	[self.exhManegedObj setValue:[NSDate date] forKey:@"collect_date"];
	
	NSError *saveError = nil;
	[self.context save:&saveError];
	
	if (saveError) {
		NSLog(@"saveError: \n UserInfo => %@ \n Description => %@", [saveError userInfo], [saveError localizedDescription]);
	} else {
		NSLog(@"已儲存展覽資訊。");
	}
}

#pragma mark - location

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
	NSLog(@"region: %@", region);

//	[self.locationManager startUpdatingLocation];
//	CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
//	[self getBeaconLinkedObjByBeacon:beaconRegion];

//	[manager startRangingBeaconsInRegion:beaconRegion];
	
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
	
	NSLog(@"exit region: %@", region);
	// Exited the region
	
	CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
	[self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager
		didRangeBeacons:(NSArray *)beacons
			   inRegion:(CLBeaconRegion *)region {
	NSLog(@"%@", region);
	
	CLBeacon *foundBeacon = [beacons firstObject];
	NSLog(@"Same Beacon: %d", ![foundBeacon.major isEqual:self.nowBeacon.major]);
//	for (CLBeacon *foundBeacon in beacons) {
//		NSLog(@"%@", foundBeacon);
//		if (foundBeacon.proximity == CLProximityNear) {
			NSString *uuid = foundBeacon.proximityUUID.UUIDString;
			NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
			NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
			NSLog(@"foundBeacon %@/%@/%@/%ld", uuid, major ,minor, (long)foundBeacon.proximity);
//		}
//	}
		if (![foundBeacon.major isEqual:self.nowBeacon.major] && foundBeacon.proximity == CLProximityNear) {
			[self getBeaconLinkedObjByBeacon:foundBeacon];
			self.nowBeacon = foundBeacon;
			NSLog(@"Same Beacon: %d", ![foundBeacon.major isEqual:self.nowBeacon.major]);
		}
	
	//	 You can retrieve the beacon data from its properties
//	NSString *uuid = foundBeacon.proximityUUID.UUIDString;
//	NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
//	NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
//	NSLog(@"%@/%@/%@", uuid, major ,minor);
	
}

-(BOOL)getBeaconLinkedObjByBeacon:(CLBeacon *)beacon {
	
	// get ibeacon link obj info via url
//	CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
	NSString *urlString = [NSString stringWithFormat:@"%@/get_iBeacon_link_obj/%@/%@/%@", kWebAPIRoot, beacon.proximityUUID.UUIDString, beacon.major, beacon.minor];
	NSURL *url = [NSURL URLWithString: urlString];
	NSError *dataError, *jsonError;
	NSData *data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&dataError];
	NSLog(@"URL: %@", urlString);
	if (dataError) {
		NSLog(@"dataError: \n UserInfo => %@ \n Description => %@", [dataError userInfo], [dataError localizedDescription]);
		return NO;
	}
	
	NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
	if (jsonError) {
		NSLog(@"jsonError: \n UserInfo => %@ \n Description => %@", [jsonError userInfo], [jsonError localizedDescription]);
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
	
	// 判斷物件類型，若不在展覽內跳出 alert
	if ([objType isEqualToString:@"exh"] && self.exhID < 0 && objID != self.exhID) {
				
		// 如果 app 在背景用推播通知 user
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
			[self sendLocalNotificationWithMessage:[NSString stringWithFormat:@"%@", [self.objData objectForKey:@"push_content"]]];
		}
		// Show alert with action btns
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"偵測到展覽！"
																				 message:[NSString stringWithFormat:@"您正在靠近「%@」，是否開始導覽？", objTitle]
																		  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"開始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[self performSegueWithIdentifier: @"MoniterExh" sender:self];
		}];
		[alertController addAction:cancelAction];
		[alertController addAction:okAction];
		
		alertController.view.backgroundColor = UIColorFromRGBWithAlpha(0xF9F7F3, 1);
		alertController.view.tintColor = UIColorFromRGBWithAlpha(0x29ABE2, 1);
		alertController.view.layer.cornerRadius = 5;
		
		[self presentViewController:alertController animated:YES completion:nil];
		
	// 若類型為展品，屬於當前展覽才需顯示
	} else if ([objType isEqualToString:@"item"] && objID != self.currentItemID && [[self.objData objectForKey:@"exh_id"] integerValue] == self.exhID) {
		self.currentItemID = objID;
        // 如果 app 在背景用推播通知 user
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
            [self sendLocalNotificationWithMessage:[NSString stringWithFormat:@"%@", [self.objData objectForKey:@"push_content"]]];
        }
		
		NSLog(@"展品 %@ 屬於展覽 %@", @(objID), @(self.exhID));
		NSLog(@"topicID = %@, topicItems => %@", @(self.topicID), self.topicItems);
		
		// 未選擇精選主題 || 有選擇精選主題且屬於當前精選主題
		if (self.topicID == 0 || (self.topicID != 0 && [self.topicItems count] > 0 && [self.topicItems containsObject:@(objID).stringValue])) {
			
			NSLog(@"展品 %@ 在精選主題 %@ 中", @(objID), @(self.topicID));
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
	
	//  若是設備且推播設定為開啟，立刻推播或顯示提示訊息
	} else if ([objType isEqualToString:@"fac"] && [[self.objData valueForKey:@"exh_id"] intValue] == self.exhID &&[iBGGlobalData sharedInstance].facilityPushIsOn) {
		
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
			
			[self sendLocalNotificationWithMessage:[NSString stringWithFormat:@"%@", [self.objData objectForKey:@"push_content"]]];
			
		} else {
			
			MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
			hud.mode = MBProgressHUDModeCustomView;
			// hud.margin = 10.f;
			hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Info.png"]];
			hud.labelText = [self.objData valueForKey:@"push_content"];
			hud.removeFromSuperViewOnHide = YES;
			[hud hide:YES afterDelay:2];
			
		}
		
	} else if ([objType isEqualToString:@"exit"] && self.exhID > 0) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您要離開了嗎？"
																				 message:[NSString stringWithFormat:@"您正在靠近「%@」之出口，確定要結束導覽了嗎？", objTitle]
																		  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"繼續導覽" style:UIAlertActionStyleCancel handler:nil];
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"結束導覽" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			self.exhID = -1;
			[self performSegueWithIdentifier:@"MoniterExit" sender:self];
		}];
		[alertController addAction:cancelAction];
		[alertController addAction:okAction];
		
		alertController.view.backgroundColor = UIColorFromRGBWithAlpha(0xF9F7F3, 1);
		alertController.view.tintColor = UIColorFromRGBWithAlpha(0x29ABE2, 1);
		alertController.view.layer.cornerRadius = 5;
		
		[self presentViewController:alertController animated:YES completion:nil];
		
	
	}
	
	return YES;
}

- (void)sendLocalNotificationWithMessage:(NSString *)message {
	UILocalNotification *notification = [[UILocalNotification alloc] init];
	notification.alertBody = message;
	notification.soundName = UILocalNotificationDefaultSoundName;
	[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

#pragma mark - Testing Btn Click Action Methods

- (IBAction)clickExhTest:(id)sender {
	
	NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"D3556E50-C856-11E3-8408-0221A885EF40"];
	CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:20431 minor:18650 identifier:kBeaconIdentifier(1)];
	// get obj data linked to the region
//	[self getBeaconLinkedObjByBeacon:region];
}

- (IBAction)clickItemTest:(id)sender {
	
	NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
	CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:28256 minor:20775 identifier:kBeaconIdentifier(1)];
	
	NSMutableArray *regionArr = [NSMutableArray arrayWithObject:region];
	
	region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:1560 minor:3897 identifier:kBeaconIdentifier(1)];
	[regionArr addObject:region];
	
	region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:56991 minor:7238 identifier:kBeaconIdentifier(1)];
	[regionArr addObject:region];
	
	[self getBeaconLinkedObjByBeacon:regionArr[arc4random() % 3]];
	//	[self performSegueWithIdentifier:@"MoniterItem" sender:self];
	
}

- (IBAction)clickSectionTest:(id)sender {
	
	[self performSegueWithIdentifier:@"MoniterSec" sender:self];
	
}

- (IBAction)clickExitTest:(id)sender {
	
	NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
	CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:beaconUUID major:23235 minor:64899 identifier:kBeaconIdentifier(15)];
//	[self getBeaconLinkedObjByBeacon:region];
	
	
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// 設定 nav bar 標題
	[segue destinationViewController].navigationItem.title = self.exhTitle;
	
	// 抓到展覽訊號去展覽資訊頁面
	if ([segue.identifier isEqualToString:@"MoniterExh"]) {
//		NSLog(@"Go exhID: %ld", (long)self.exhID);
		[[segue destinationViewController] setValue:self.objData forKey:@"exhInfo"];
	
	}
	
	// 出口訊號去出口頁面
	else if ([segue.identifier isEqualToString:@"MoniterExit"]) {
		NSLog(@"Exit for : %ld", (long)self.exhID);
		self.exhID = 0;
		[[segue destinationViewController] setValue:self.exhInfo forKey:@"exhInfo"];
	}
	
	// 抓到有展區的展品訊號去展區資訊頁面
	else if ([segue.identifier isEqualToString:@"MoniterSec"]) {
		NSLog(@"Go topicID: %ld, secID: %@", (long)self.topicID, [self.objData objectForKey:@"sec_id"]);
		[[segue destinationViewController] setValue:self.objData forKey:@"prepareItemInfo"];	}
	
	// 抓到沒有展區的展品訊號去展品資訊頁面
	else if ([segue.identifier isEqualToString:@"MoniterItem"]) {
		NSLog(@"Go itemID: %@", [self.objData objectForKey:@"id"]);
		[[segue destinationViewController] setValue:self.objData forKey:@"itemInfo"];
	}
	
}

@end
