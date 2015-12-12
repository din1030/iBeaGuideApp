//
//  iBGItemCommentViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGGlobal.h"
#import "MBProgressHUD.h"
#import "iBGCommentViewController.h"

@interface iBGCommentViewController ()

@end

@implementation iBGCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.tapDismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
	[self.view addGestureRecognizer:self.tapDismissKB];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
	CALayer *inputLayer = [[iBGTextInputLayer alloc] init];
	inputLayer.frame = self.commentTextView.bounds;
	[self.commentTextView.layer addSublayer:inputLayer];
	
	self.starArr = @[self.star1, self.star2, self.star3, self.star4, self.star5];
	
//	self.rate = 3;


//	CALayer *inputTitleLayer = [[iBGTextInputLayer alloc] init];
//	inputTitleLayer.frame = self.commentTitleTextField.bounds;
//	[self.commentTitleTextField.layer addSublayer:inputTitleLayer];
	
}
- (IBAction)clickRateStar:(UIButton *)sender {
	
	int index = (int)[self.starArr indexOfObject:sender];
	self.rate = index+1;
	for (int i = 0; i < [self.starArr count]; i++) {
		// 評分的星星亮起來
		if (i < self.rate) {
			UIButton *currentBtn = (UIButton *)self.starArr[i];
			[currentBtn setBackgroundImage:[UIImage imageNamed:@"star_on.png"] forState:UIControlStateNormal];
		// 大於評分的星星關掉
		} else {
			UIButton *currentBtn = (UIButton *)self.starArr[i];
			[currentBtn setBackgroundImage:[UIImage imageNamed:@"star_off.png"] forState:UIControlStateNormal];
		}
		
	}
	NSLog(@"Rate: %d", self.rate);
}

- (IBAction)clickSendComment:(id)sender {
	// 檢查有評分才可以送出
	if (self.rate) {
	
		NSArray *commentObjArray = [NSArray arrayWithObjects: @"1", self.objID, self.type, @(self.rate), self.commentTextView.text, nil];
		NSArray *commentKeyArray = [NSArray arrayWithObjects: @"user_id", @"obj_id", @"type", @"rate", @"content", nil];
		NSDictionary *comment = [NSDictionary dictionaryWithObjects:commentObjArray forKeys:commentKeyArray];
		[self sendCommentData:comment url:@"http://114.34.1.57/iBeaGuide/App/post_comment_action"];

		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.mode = MBProgressHUDModeCustomView;
		// hud.margin = 10.f;
		hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
		hud.labelText = @"已送出";
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:YES afterDelay:2];
		
		[self.navigationController popViewControllerAnimated:YES];
	
	} else {
		
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
		hud.mode = MBProgressHUDModeCustomView;
		// hud.margin = 10.f;
		hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Warning.png"]];
		hud.labelText = @"尚未評分";
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:YES afterDelay:2];
		
		// Show alert with action btns
//		UIAlertController *noRateAlertController = [UIAlertController alertControllerWithTitle:@"尚未評分"
//																				 message:@"請先點選評分再將留言送出，謝謝！"
//																		  preferredStyle:UIAlertControllerStyleAlert];
//		
//		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我要評分" style:UIAlertActionStyleCancel handler:nil];
//
//		[noRateAlertController addAction:okAction];
//		
//		noRateAlertController.view.backgroundColor = UIColorFromRGBWithAlpha(0xF9F7F3, 1);
//		noRateAlertController.view.tintColor = UIColorFromRGBWithAlpha(0x29ABE2, 1);
//		noRateAlertController.view.layer.cornerRadius = 5;
//		
//		[self presentViewController:noRateAlertController animated:YES completion:nil];
	}
}

- (void)sendCommentData:(NSDictionary *)commentData url:(NSString *)urlString {
	
	NSError *jsonError, *requestError;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commentData
													   options:0 // Pass 0 if you don't care about the readability of the generated string
														 error:&jsonError];
	if (jsonError) {
		NSLog(@"留言資料轉換錯誤");
		NSLog(@"jsonError: \n UserInfo => %@ \n Description => %@",[jsonError userInfo], [jsonError localizedDescription]);
	
		return;
	}
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:jsonData];
	
	//轉換為NSData傳送
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&requestError];
	if (requestError) {
		NSLog(@"留言資料傳送錯誤");
		NSLog(@"requestError: \n UserInfo => %@ \n Description => %@",[requestError userInfo], [requestError localizedDescription]);
	
		return;
	}
	
	NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

}

- (void)keyboardWasShown:(NSNotification *)notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
	int height = keyboardRect.size.height;
	[self.commentScrollView setFrame:CGRectMake(0, 0, 320.0, self.view.frame.size.height - height)];
	//	NSLog(@"%f", self.view.frame.size.height - height);
	
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.commentScrollView.subviews) {
		contentRect = CGRectUnion(contentRect, view.frame);
	}
	[self.commentScrollView setContentSize:contentRect.size];
	
}

- (void)keyboardWillHide:(NSNotification *)notification {
	
	[self.commentScrollView setFrame:CGRectMake(0, 0, 320.0, self.view.frame.size.height)];
	//	NSLog(@"%f", self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)dismissKB {
	[self.view endEditing:YES];
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
