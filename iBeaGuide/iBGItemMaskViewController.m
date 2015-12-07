//
//  iBGItemMaskViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/4.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "AppDelegate.h"
#import "iBGItemMaskViewController.h"
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
	[item setValue:[self.itemInfo objectForKey:@"brief"] forKey:@"itemBrief"];
	[item setValue:[self.itemInfo objectForKey:@"description"] forKey:@"itemDescription"];
	
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
	
	
	
	NSError *saveError = nil;
	[self.context save:&saveError];

	NSString *alertTitle, *alertMsg, *alertActionTitle;
	if (saveError) {
		alertTitle = @"加入我的收藏失敗";
		alertMsg = @"請稍後再試。";
		alertActionTitle = @"好";
		NSLog(@"saveError: %@",[saveError description]);
	} else {
		alertTitle = @"已加入我的收藏";
		alertMsg = @"您可以在收藏頁面隨時觀看收藏的展品。";
		alertActionTitle = @"好";
	
	}
	UIAlertController *collectAlertController = [UIAlertController alertControllerWithTitle:alertTitle
																				   message:alertMsg
																			preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:alertActionTitle style:UIAlertActionStyleCancel handler:nil];
	
	[collectAlertController addAction:okAction];
	
	collectAlertController.view.backgroundColor = UIColorFromRGBWithAlpha(0xF9F7F3, 1);
	collectAlertController.view.tintColor = UIColorFromRGBWithAlpha(0x29ABE2, 1);
	collectAlertController.view.layer.cornerRadius = 5;
	
	[self presentViewController:collectAlertController animated:YES completion:nil];

}

- (IBAction)clickShareBtn:(UIButton *)sender {
	if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
		[self doShareOGACtion];
	} else {
		FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
		[loginManager logInWithPublishPermissions:@[@"publish_actions"]
							   fromViewController:self
										  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
											  if (error) {
												  // Process error
											  } else if (result.isCancelled) {
												  // Handle cancellations
											  } else {
												  [self doShareOGACtion];
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
								 @"og:image": @[photo]
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
