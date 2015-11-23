//
//  iBGHomeViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/22.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGHomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface iBGHomeViewController ()

@end

@implementation iBGHomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// Handle clicks on the button
	[self.FBLoginBtn
	 addTarget:self
	 action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	[self.registerBtn
	 addTarget:self
	 action:@selector(share) forControlEvents:UIControlEventTouchUpInside];}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
	FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
	[login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
				 fromViewController:self
							handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
								if (error) {
									NSLog(@"Process error");
								} else if (result.isCancelled) {
									NSLog(@"Cancelled");
								} else {
									NSLog(@"Logged in");
								}
							}];
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
	NSURL *imageURL = [NSURL URLWithString:@"http://secrt.nccu.edu.tw/newsimages/011222open_7.jpg"];
	FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImageURL:imageURL userGenerated:NO];
	NSDictionary *properties = @{
								 @"og:type": @"chengchiating:exhibit",
								 @"og:title": @"水岸大怒神",
								 @"og:description": @"濕滑是建設電梯之人，我們就是多繳學雜費用的人，電梯建設、要捐贈、要減車不管師生的過問，只管哈佛的精神～",
								 @"og:url": @"https://www.ptt.cc/bbs/NCCU/M.1366372453.A.DC0.html",
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
