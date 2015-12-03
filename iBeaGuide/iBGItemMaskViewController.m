//
//  iBGItemMaskViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/4.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemMaskViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface iBGItemMaskViewController ()

@end

@implementation iBGItemMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tapMaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMaskView)];
	[self.itemMaskView addGestureRecognizer:self.tapMaskView];
	
	[self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];

    // Do any additional setup after loading the view.
	
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

- (void)share {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickMenuOptionBtn:(id)sender {
	if (sender == self.msgBtn) {
		[self.parentViewController performSegueWithIdentifier:@"itemComment" sender:self];
	} else if (sender == self.addBtn) {
		[self.parentViewController performSegueWithIdentifier:@"itemComment" sender:self];
	}
	
}

@end
