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
	self.pageParentVC = (iBGItemPageParentViewController*)self.parentViewController.parentViewController;
	[self.view bringSubviewToFront:self.pageParentVC.itemMenuBtn];
	

	CGRect txtFrame = self.itemBrief.frame;
	
//	self.itemBrief.frame = CGRectMake(25, 368, 270,
//							 txtFrame.size.height =[self.itemBrief.text boundingRectWithSize:
//													CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
//																			options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//																		 attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.itemBrief.font,NSFontAttributeName, nil] context:nil].size.height);
//	self.itemBrief.frame = CGRectMake(25, 368, 270, txtFrame.size.height);
	
	txtFrame.size.height = [self.itemBrief.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
															 options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
														  attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.itemBrief.font,NSFontAttributeName, nil] context:nil].size.height;
	self.itemBrief.frame = txtFrame;
	
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.itemInfoScrollView.subviews) {
		contentRect = CGRectUnion(contentRect, view.frame);
	}
//	contentRect.size.height += 30;
//	self.itemInfoScrollView.contentSize = contentRect.size;
	
	if (contentRect.size.height > self.itemInfoScrollView.frame.size.height) {
		contentRect.size.height += 30;
		self.itemInfoScrollView.contentSize = contentRect.size;
	} else {
		self.itemInfoScrollView.contentSize = CGSizeMake(320, 504
);
	}

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
