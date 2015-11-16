//
//  iBGExhInfoViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/10/28.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGExhInfoViewController.h"
#import "iBGMoniterViewController.h"

@interface iBGExhInfoViewController ()

@end

@implementation iBGExhInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 取出展覽資料 assign 給對應的 label
//	self.exhNavItem.title = [self.exhInfo objectForKey:@"title"];
	// 如果展期只有一天只需顯示單一日期
	if ([self.exhInfo objectForKey:@"start_date"] == [self.exhInfo objectForKey:@"end_date"]) {
		self.exhDate.text = [NSString stringWithFormat:@"%@", [self.exhInfo objectForKey:@"start_date"]];
	} else {
		self.exhDate.text = [NSString stringWithFormat:@"%@ ~ %@", [self.exhInfo objectForKey:@"start_date"], [self.exhInfo objectForKey:@"end_date"]];
	}
	NSString *openTime = [[self.exhInfo objectForKey:@"daily_open_time"] substringWithRange:NSMakeRange(0, [[self.exhInfo objectForKey:@"daily_open_time"] length]-3)];
	NSString *closeTime = [[self.exhInfo objectForKey:@"daily_close_time"] substringWithRange:NSMakeRange(0, [[self.exhInfo objectForKey:@"daily_close_time"] length]-3)];
	self.exhTime.text = [NSString stringWithFormat:@"%@ - %@", openTime, closeTime];
	self.exhVenue.text = [self.exhInfo objectForKey:@"venue"];
	self.exhSite.text = [self.exhInfo objectForKey:@"web_link"];
	self.exhDescription.text = [self.exhInfo objectForKey:@"description"];
//	self.exhDescription.text = @"想說最後一場了所以提早一個小時去排隊，所以大概有站到前三分之一的位置。但 50mm 拍起來還是稍嫌有點遠，旁邊大叔的大砲都可以拍到特寫哈哈。蠻喜歡當天的燈光的，看的時候不會被強光刺眼，拍起來的感覺也還不錯～過去看 live 鼓手總是很孤獨的在最後面，也許是短期內最後的巡迴了，春佑被拉到很前面，也是難得的舞台配置。不過因為鼓組的關係也是很難同時拍到他跟其他人。總之這是一場讓人蠻滿足的表演，而且沒想到後來還在 Instagram 上遇到了當天排隊認識的朋友，緣份就是如此的奇妙哈哈～好想聽被溺愛的渴望啊！！！";
	
	// 判斷說明文字的高度
	CGRect txtFrame = self.exhDescription.frame;
	txtFrame.size.height = [self.exhDescription.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
																  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
															   attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.exhDescription.font,NSFontAttributeName, nil]
																  context:nil].size.height;
	self.exhDescription.frame = txtFrame;
	
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
