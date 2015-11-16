//
//  iBGItemInfoViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemInfoViewController.h"

@interface iBGItemInfoViewController ()

@end

@implementation iBGItemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self.itemMainPic setContentMode:UIViewContentModeScaleAspectFill];
	[self.itemMainPic setImage:[UIImage imageNamed:@"Mona_Lisa.jpg"]];
	
	self.pageParentVC = (iBGItemPageParentViewController*)self.parentViewController.parentViewController;
	[self.view bringSubviewToFront:self.pageParentVC.itemMenuBtn];
	

	CGRect txtFrame = self.itemBrief.frame;	
	txtFrame.size.height = [self.itemBrief.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
															 options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
														  attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.itemBrief.font,NSFontAttributeName, nil] context:nil].size.height;
	self.itemBrief.frame = txtFrame;
	
	// 取 scrollview 所有 subview 的 frame 的聯集
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.itemInfoScrollView.subviews) {
		// 最後的捲軸 UIImageView 固定是 568 所以不要去算他
		if (![view isKindOfClass:[UIImageView class]]) {
			contentRect = CGRectUnion(contentRect, view.frame);
		}
	}
	
	// 增加與底部按鈕距離
	contentRect.size.height += 10.0;
	self.itemInfoScrollView.contentSize = contentRect.size;

}

- (void)viewDidAppear:(BOOL)animated {
	// 控制 page control 到對應位置
	self.pageParentVC = (iBGItemPageParentViewController*)self.parentViewController.parentViewController;
	self.pageParentVC.itemPageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickItemMenu:(id)sender {
	
	UIPageViewController *PVC = (UIPageViewController*)self.parentViewController;
	[PVC setViewControllers:@[self] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	UIViewController *maskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemMaskVC"];
	[self.parentViewController addChildViewController:maskVC];
	[self.parentViewController.view addSubview:maskVC.view];	
	//	[self.view bringSubviewToFront:maskVC.view];
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
