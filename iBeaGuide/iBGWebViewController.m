//
//  iBGWebViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/16.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGWebViewController.h"

@interface iBGWebViewController ()

@end

@implementation iBGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.webView.delegate = self;
	self.firstRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
	[self.webView loadRequest:self.firstRequest];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (request == self.firstRequest) {
		[self.activityIndicator startAnimating];
	}
	return YES;
}

//- (void)webViewDidStartLoad:(UIWebView *)webView {
//	[self.activityIndicator stopAnimating];
//	self.activityIndicator.hidden = NO;
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
	[self.activityIndicator stopAnimating];
	if (error) {
		NSLog(@"webFailLoadError: \n UserInfo => %@ \n Description => %@",[error userInfo], [error localizedDescription]);
		
	}
}

@end
