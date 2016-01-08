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
#import "iBGGlobalData.h"

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
								[[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, first_name, last_name, name, email, birthday, gender"}]
								 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
									 if (!error) {
										 NSLog(@"fetched user:%@", result);
										 
										 NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithDictionary:(NSMutableDictionary *)result];
										 [userData setObject:[userData objectForKey: @"id"] forKey: @"fb_id"];
										 [userData removeObjectForKey: @"id"];
										 [userData setObject:@"visitor" forKey: @"user_type"];
										 
										 NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
										 [dateFormater setDateFormat:@"MM/dd/yyyy"];
										 NSDate *birthday = [dateFormater dateFromString:userData[@"birthday"]];
										 
										 [dateFormater setDateFormat:@"yyyy-MM-dd"];
										 userData[@"birthday"] = [dateFormater stringFromDate:birthday];
										 
										 [self sendUserData:userData url:@"http://114.34.1.57/iBeaGuide/App/post_user_action"];
										 [self performSegueWithIdentifier:@"HomeToMoniter" sender:self];
									 }
								 }];
							}
						}
					}];
	}
	
}

- (void)sendUserData:(NSDictionary *)userData url:(NSString *)urlString {
	
	NSError *jsonError, *requestError;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userData
													   options:0 // Pass 0 if you don't care about the readability of the generated string
														 error:&jsonError];
	if (jsonError) {
		NSLog(@"使用者資料轉換錯誤");
		NSLog(@"jsonError: \n UserInfo => %@ \n Description => %@",[jsonError userInfo], [jsonError localizedDescription]);
		
		return;
	}
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:jsonData];
	
	//轉換為NSData傳送
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&requestError];
	if (requestError) {
		NSLog(@"使用者資料傳送錯誤");
		NSLog(@"requestError: \n UserInfo => %@ \n Description => %@", [requestError userInfo], [requestError localizedDescription]);
		
		return;
	}
	
	NSNumber *userID = @([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding].intValue);
	[iBGGlobalData sharedInstance].loggedUserID = userID;
	NSLog(@"user ID: %@", userID);
	
}

@end
