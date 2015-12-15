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

@interface iBGHomeViewController ()

@end

@implementation iBGHomeViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Handle clicks on the button
	[self.FBLoginBtn
	 addTarget:self
	 action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	
	[self.registerBtn
	 addTarget:self
	 action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidAppear:(BOOL)animated {
	
	if ([FBSDKAccessToken currentAccessToken]) {
		[self performSegueWithIdentifier:@"HomeToMoniter" sender:self];
	}
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked {
	
	if (![FBSDKAccessToken currentAccessToken]) {
		FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
		[login logInWithReadPermissions: @[@"public_profile", @"email", @"user_birthday"]
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
										 [self performSegueWithIdentifier:@"HomeToMoniter" sender:self];
									 }
								 }];
							}
						}
					}];
	}
	
}

@end
