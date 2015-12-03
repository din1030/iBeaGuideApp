//
//  iBGItemCommentViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemCommentViewController.h"

@interface iBGItemCommentViewController ()

@end

@implementation iBGItemCommentViewController

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

//	CALayer *inputTitleLayer = [[iBGTextInputLayer alloc] init];
//	inputTitleLayer.frame = self.commentTitleTextField.bounds;
//	[self.commentTitleTextField.layer addSublayer:inputTitleLayer];
	
}

- (void)keyboardWasShown:(NSNotification *)notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
	int height = keyboardRect.size.height;
	[self.commentScrollView setFrame:CGRectMake(0, 0, 320.0, self.view.frame.size.height - height)];
	NSLog(@"%f", self.view.frame.size.height - height);
	
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

- (IBAction)clickSendComment:(id)sender {
	
	NSArray *commentObjArray = [NSArray arrayWithObjects: @"1", @"17", @"exh", @"3", self.commentTextView.text, nil];
	NSArray *commentKeyArray = [NSArray arrayWithObjects: @"user_id", @"obj_id", @"type", @"rate", @"content", nil];
	
	NSDictionary *comment = [NSDictionary dictionaryWithObjects:commentObjArray forKeys:commentKeyArray];
	
	[self sendCommentData:comment url:@"http://114.34.1.57/iBeaGuide/App/post_comment_action"];

}

- (void)sendCommentData:(NSDictionary *)commentData url:(NSString *)urlString {

	
//	NSMutableString *postString = [NSMutableString stringWithString:urlString];
//	
//	[postString appendString:@"?ibg=111"];
//	for (NSString *key in commentData) {
//		[postString appendString:[NSString stringWithFormat:@"&%@=%@", key, [commentData objectForKey:key]]];
//	}
//	NSLog(@"%@", postString);
	
//	[postString setString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	NSError *error;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:commentData
													   options:0 // Pass 0 if you don't care about the readability of the generated string
														 error:&error];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:jsonData];
	
//	NSURLConnection *postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	
	//轉換為NSData傳送
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
