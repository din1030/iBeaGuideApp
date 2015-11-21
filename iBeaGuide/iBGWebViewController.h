//
//  iBGWebViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/16.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iBGWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSString *urlString;
@property NSURLRequest *firstRequest;
@end
