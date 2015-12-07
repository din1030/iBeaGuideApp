//
//  iBGExhInfoViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/10/28.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGExhInfoViewController.h"
#import "iBGMoniterViewController.h"
#import "UILabel+AutoHeight.h"

@interface iBGExhInfoViewController ()

@end

@implementation iBGExhInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 取出展覽資料 assign 給對應的 label
	// 如果展期只有一天只需顯示單一日期
	if ([self.exhInfo objectForKey:@"start_date"] == [self.exhInfo objectForKey:@"end_date"]) {
		self.exhDate.text = [NSString stringWithFormat:@"%@", [self.exhInfo objectForKey:@"start_date"]];
	} else {
		self.exhDate.text = [NSString stringWithFormat:@"%@ ~ %@", [self.exhInfo objectForKey:@"start_date"], [self.exhInfo objectForKey:@"end_date"]];
	}
	self.exhDate.text = [self.exhDate.text stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
	NSString *openTime = [[self.exhInfo objectForKey:@"daily_open_time"] substringWithRange:NSMakeRange(0, [[self.exhInfo objectForKey:@"daily_open_time"] length]-3)];
	NSString *closeTime = [[self.exhInfo objectForKey:@"daily_close_time"] substringWithRange:NSMakeRange(0, [[self.exhInfo objectForKey:@"daily_close_time"] length]-3)];
	self.exhTime.text = [NSString stringWithFormat:@"%@ - %@", openTime, closeTime];
	self.exhVenue.text = [self.exhInfo objectForKey:@"venue"];
	
	// 判斷是從 MySQL DB 還是 Core Data 來的資料， description 欄位名稱不同
	if ([[self.exhInfo allKeys] containsObject:@"ibeacon_id"]) {
		self.exhDescription.text = [self.exhInfo objectForKey:@"description"];
	} else {
		self.exhDescription.text = [self.exhInfo objectForKey:@"exhDescription"];
	}
	
	
	// 如果沒有網址就不要顯示，把說明往上拉
	NSString *webURL = [self.exhInfo objectForKey:@"web_link"];
	if (webURL == (id)[NSNull null] || webURL.length == 0) {
		self.exhSiteLbl.hidden = YES;
		self.exhSiteBtn.hidden = YES;
		CGRect newDesframe = self.exhDescription.frame;
		newDesframe.origin = self.exhSiteLbl.frame.origin;
		newDesframe.origin.y += 10;
		self.exhDescription.frame = newDesframe;
	}

    [self.exhDescription autoHeight];
	
	// 取scrollview 所有 subview 的 frame 的聯集
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.exhScrollView.subviews) {
		// 最後的捲軸 UIImageView 固定是 568 所以不要去算他
		if (![view isKindOfClass:[UIImageView class]]) {
			contentRect = CGRectUnion(contentRect, view.frame);
		}
	}
	
	// 增加與底部按鈕距離
	contentRect.size.height += 10.0;
	self.exhScrollView.contentSize = contentRect.size;
}

- (void)viewDidAppear:(BOOL)animated {
	// 控制 page control 到對應位置
	self.pageParentVC = (iBGExhPageParentViewController*)self.parentViewController.parentViewController;
	self.pageParentVC.exhPageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	if ([[segue identifier] isEqualToString:@"openWebView"] && !self.exhSiteBtn.hidden) {
		[[segue destinationViewController] setValue:[self.exhInfo objectForKey:@"web_link"] forKey:@"urlString"];
	}
}


- (IBAction)clickExhSiteBtn:(id)sender {
}


@end
