//
//  iBGExitViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/12/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGExitViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface iBGExitViewController ()

@end

@implementation iBGExitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickShareBtn:(id)sender {
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
	NSLog(@"exhID: %@", [self.exhInfo objectForKey:@"id"]);
	NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://114.34.1.57/iBeaGuide/user_uploads/User_1/User_1_exh_%@.jpg", [self.exhInfo objectForKey:@"id"]]];
	FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImageURL:imageURL userGenerated:NO];
	NSDictionary *properties = @{
								 @"og:type": @"chengchiating:exhibition",
								 @"og:title": [self.exhInfo objectForKey:@"title"],
								 @"og:description": [self.exhInfo objectForKey:@"description"],
								 @"og:url": @"http://www.dct.nccu.edu.tw/master/",
								 @"og:image": @[photo],
								 @"chengchiating:dates": [NSString stringWithFormat:@"%@ - %@", [self.exhInfo objectForKey:@"start_date"], [self.exhInfo objectForKey:@"end_date"]],
								 @"chengchiating:venue": [NSString stringWithFormat:@"%@", [self.exhInfo objectForKey:@"venue"]]
								 };
	FBSDKShareOpenGraphObject *object = [FBSDKShareOpenGraphObject objectWithProperties:properties];
	FBSDKShareAPI *shareAPI = [[FBSDKShareAPI alloc] init];
	[shareAPI createOpenGraphObject:object];
	FBSDKShareOpenGraphAction *action = [[FBSDKShareOpenGraphAction alloc] init];
	action.actionType = @"chengchiating:visited";
	[action setObject:object forKey:@"exhibition"];
	FBSDKShareOpenGraphContent *ogcontent = [[FBSDKShareOpenGraphContent alloc] init];
	ogcontent.action = action;
	ogcontent.previewPropertyName = @"exhibition";
	shareAPI.shareContent = ogcontent;
	[shareAPI share];
	
	[FBSDKShareDialog showFromViewController:self
								 withContent:ogcontent
									delegate:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// 去留言頁面
	if ([segue.identifier isEqualToString:@"CommentExh"]) {
		[segue destinationViewController].navigationItem.title = [self.exhInfo objectForKey:@"title"];
		[[segue destinationViewController] setValue:@"exh" forKey:@"type"];
		[[segue destinationViewController] setValue:[self.exhInfo objectForKey:@"id"] forKey:@"objID"];
	}
}


@end
