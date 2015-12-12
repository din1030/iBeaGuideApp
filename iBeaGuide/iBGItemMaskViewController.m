//
//  iBGItemMaskViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/4.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "AppDelegate.h"
#import "iBGGlobal.h"
#import "iBGItemMaskViewController.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface iBGItemMaskViewController ()

@property NSManagedObjectContext *context;

@end

@implementation iBGItemMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tapMaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMaskView)];
	[self.itemMaskView addGestureRecognizer:self.tapMaskView];

}

- (void)removeMaskView {
	
	// 先 disable 按鈕然後讓 mask view fade out + remove
	self.msgBtn.enabled = false;
	self.addBtn.enabled = false;
	self.shareBtn.enabled = false;
	[UIView animateWithDuration:0.5f animations:^{
		[self.view setAlpha:0.0f];
	} completion:^(BOOL completion){
		[self.view removeFromSuperview];
	}];
	//	[self removeFromParentViewController];
}

- (IBAction)clickCommentBtn:(UIButton *)sender {
	[self.parentViewController performSegueWithIdentifier:@"ItemComment" sender:self];
}

- (IBAction)clickCollectBtn:(UIButton *)sender {
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	self.context = [appDelegate managedObjectContext];
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
	[request setPredicate:[NSPredicate predicateWithFormat:@"id = %@", [self.itemInfo valueForKey:@"id"]]];
	[request setFetchLimit:1];
	
	NSError *fetchError;
	NSUInteger count = [self.context countForFetchRequest:request error:&fetchError];
	if (count > 0) {
		
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.mode = MBProgressHUDModeCustomView;
		hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Warning.png"]];
		hud.labelText = @"您已收藏過本展品";
		// hud.margin = 10.f;
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:YES afterDelay:2];
		NSLog(@"展品已在使用者收藏中。");
		
		return;
	} else if (count == NSNotFound) {
		if (fetchError) {
			NSLog(@"Collected item fetchError: \n UserInfo => %@ \n Description => %@",[fetchError userInfo], [fetchError localizedDescription]);
		}
	}
	
	// 建立一個要 insert 的物件
	NSEntityDescription *itemEntity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
	NSManagedObject *item = [[NSManagedObject alloc] initWithEntity:itemEntity insertIntoManagedObjectContext:self.context];

	for (NSString *key in [[itemEntity attributesByName] allKeys]) {
		if ([[self.itemInfo allKeys] containsObject:key]) {
			if ([[itemEntity attributesByName] objectForKey:key].attributeType == NSInteger16AttributeType) {
				[item setValue:@([[self.itemInfo objectForKey:key] intValue]) forKey:key];
			} else {
				[item setValue:[self.itemInfo objectForKey:key] forKey:key];
			}
			NSLog (@"%@ => %@", key, [item valueForKey:key]);
		}
	}
	[item setValue:[self.itemInfo objectForKey:@"description"] forKey:@"itemDescription"];
	[item setValue:[NSDate date] forKey:@"collect_date"];
	
	NSEntityDescription *fieldEntity = [NSEntityDescription entityForName:@"Field" inManagedObjectContext:self.context];
	NSManagedObject *field = nil;
	
	NSArray *bFieldArr = [self.itemInfo objectForKey:@"basic_field"];
	for (NSDictionary *bf in bFieldArr) {
		field = [[NSManagedObject alloc] initWithEntity:fieldEntity insertIntoManagedObjectContext:self.context];
		for (NSString *key in [[fieldEntity attributesByName] allKeys]) {
			if ([[bf allKeys] containsObject:key]) {
				if ([[fieldEntity attributesByName] objectForKey:key].attributeType == NSInteger16AttributeType) {
					[field setValue:@([[bf objectForKey:key] intValue]) forKey:key];
				} else {
					[field setValue:[bf objectForKey:key] forKey:key];
				}
				NSLog (@"%@ => %@", key, [field valueForKey:key]);
			}
		}
		[field setValue:item forKey:@"belongsItem"];
		field = nil;
	}

	NSArray *dFieldArr = [self.itemInfo objectForKey:@"detail_field"];
	for (NSDictionary *df in dFieldArr) {
		field = [[NSManagedObject alloc] initWithEntity:fieldEntity insertIntoManagedObjectContext:self.context];
		for (NSString *key in [[fieldEntity attributesByName] allKeys]) {
			if ([[df allKeys] containsObject:key]) {
				if ([[fieldEntity attributesByName] objectForKey:key].attributeType == NSInteger16AttributeType) {
					[field setValue:@([[df objectForKey:key] intValue]) forKey:key];
				} else {
					[field setValue:[df objectForKey:key] forKey:key];
				}
				NSLog (@"%@ => %@", key, [field valueForKey:key]);
			}
		}
		[field setValue:item forKey:@"belongsItem"];
		field = nil;
	}
	
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Exhibition"];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", [self.itemInfo objectForKey:@"exh_id"]];
	[fetchRequest setPredicate: predicate];
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
	// hud.margin = 10.f;
	
	fetchError = nil;
	NSArray *results = [self.context executeFetchRequest:fetchRequest error:&fetchError];
	if (fetchError) {
		
		hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Warning.png"]];
		hud.labelText = @"加入我的收藏失敗";
		hud.detailsLabelText = @"請稍後再試。";
		NSLog(@"fetchError: \n UserInfo => %@ \n Description => %@", [fetchError userInfo], [fetchError localizedDescription]);
		
	} else {

		[item setValue:results[0] forKey:@"belongsExh"];
		NSLog (@"title => %@", [results[0] valueForKey:@"title"]);
		NSLog (@"belongsExh => %@", [item valueForKey:@"belongsExh"]);
		
		NSError *saveError = nil;
		[self.context save:&saveError];

		if (saveError) {
			
			hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Warning.png"]];
			hud.labelText = @"加入我的收藏失敗";
			hud.detailsLabelText = @"請稍後再試。";
			NSLog(@"saveError: \n UserInfo => %@ \n Description => %@", [saveError userInfo],[saveError localizedDescription]);
		
		} else {
			
			hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Collect.png"]];
			hud.labelText = @"已加入我的收藏";
			hud.detailsLabelText = @"您可以在收藏頁面隨時觀看收藏的展品。";
		
		}
	}
	
//	hud.delegate = self;
	[hud show:YES];
	[hud hide:YES afterDelay:2];


}

- (IBAction)clickShareBtn:(UIButton *)sender {
	if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
		[self doShareOGACtion];
	} else {
		FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
		[loginManager logInWithPublishPermissions:@[@"publish_actions"]
							   fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *FBLoginError) {
								   if (FBLoginError) {
									   NSLog(@"FBLoginError: \n UserInfo => %@ \n Description => %@",[FBLoginError userInfo], [FBLoginError localizedDescription]);
								   } else if (result.isCancelled) {
									   NSLog(@"使用者取消 FB 登入");
								   } else {
									   NSLog(@"Logged in");
									   if ([FBSDKAccessToken currentAccessToken]) {
										   [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, first_name, last_name, email, birthday, gender"}]
											startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
												if (!error) {
													NSLog(@"fetched user:%@", result);
												}
											}];
									   }
								   }
							   }];
	}
}

-(void)doShareOGACtion {
	NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://114.34.1.57/iBeaGuide/user_uploads/User_1/User_1_item_%@_main.jpg", [self.itemInfo objectForKey:@"id"]]];
	FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImageURL:imageURL userGenerated:NO];
	NSDictionary *properties = @{
									@"og:type": @"chengchiating:exhibit",
									@"og:title": [self.itemInfo objectForKey:@"title"],
									@"og:description": [self.itemInfo objectForKey:@"brief"],
									@"og:url": @"http://www.dct.nccu.edu.tw/master/",
									@"og:image": @[photo],
									@"chengchiating:creator": [self.itemInfo objectForKey:@"creator"],
									@"chengchiating:finished_time": [self.itemInfo objectForKey:@"finished_time"]
								};
	FBSDKShareOpenGraphObject *object = [FBSDKShareOpenGraphObject objectWithProperties:properties];
	FBSDKShareAPI *shareAPI = [[FBSDKShareAPI alloc] init];
	[shareAPI createOpenGraphObject:object];
	FBSDKShareOpenGraphAction *action = [[FBSDKShareOpenGraphAction alloc] init];
	action.actionType = @"chengchiating:view";
	[action setObject:object forKey:@"exhibit"];
	FBSDKShareOpenGraphContent *ogcontent = [[FBSDKShareOpenGraphContent alloc] init];
	ogcontent.action = action;
	ogcontent.previewPropertyName = @"exhibit";
	shareAPI.shareContent = ogcontent;
	[shareAPI share];
	
	[FBSDKShareDialog showFromViewController:self
								 withContent:ogcontent
									delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
