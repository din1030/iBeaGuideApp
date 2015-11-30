//
//  iBGItemPageParentViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemPageParentViewController.h"
#import "iBGItemInfoViewController.h"
#import "iBGItemDetailViewController.h"
#import "iBGItemCommentTableViewController.h"

@interface iBGItemPageParentViewController ()

@end

@implementation iBGItemPageParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// show id
	NSLog(@"目前展品 ID： %@", [self.itemInfo objectForKey:@"id"]);
	
	// 禁止 swipe back
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	[[self navigationController] setNavigationBarHidden:NO];
	
	// Create page view controller
	self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemPageVC"];
	self.pageViewController.dataSource = self;
	//	self.pageViewController.delegate = self;
	
	if ([self.callerPage isEqualToString:@"collection"]) {
		iBGItemInfoViewController *iBGItemInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemInfoVC"];
		iBGItemDetailViewController *iBGItemDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailVC"];
		self.pageviewContentVCs = @[iBGItemInfoViewController, iBGItemDetailViewController];
		[self.pageViewController setViewControllers:@[iBGItemInfoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
		self.itemPageControl.numberOfPages = 2;
	} else {
		// 建立 page view 的 child VC (item 的 3 個頁面)
		iBGItemInfoViewController *iBGItemInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemInfoVC"];
		iBGItemDetailViewController *iBGItemDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailVC"];
		iBGItemCommentTableViewController *iBGItemCommentTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemCommentTableVC"];
		self.pageviewContentVCs = @[iBGItemInfoViewController, iBGItemDetailViewController, iBGItemCommentTableViewController];
		iBGItemCommentTableViewController.commentType = @"item";
		iBGItemCommentTableViewController.commentObjTitle = @"觀眾留言";
		iBGItemCommentTableViewController.commentObjSubtitle = @"歡迎您看完展覽後留下寶貴的意見！";
		
		[self.pageViewController setViewControllers:@[iBGItemInfoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
		self.itemPageControl.numberOfPages = 3;
	}
	
	// 把 page VC 塞給目前的 VC	
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
	
	// 把固定顯示的物件拉到最前面
	[self.view bringSubviewToFront:self.itemPageControlBG];
	[self.view bringSubviewToFront:self.itemPageControl];
	if (![self.callerPage isEqualToString:@"collection"]) {
		[self.view bringSubviewToFront:self.itemMenuBtn];
	} else {
		self.itemMenuBtn.hidden = YES;
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Page View Controller Data Delegate
//
//- (void)pageViewController:(UIPageViewController *)pageViewController
//willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
//	
//}
//
//- (void)pageViewController:(UIPageViewController *)pageViewController
//		didFinishAnimating:(BOOL)finished
//   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
//	   transitionCompleted:(BOOL)completed {
//	
//}

#pragma mark - Page View Controller Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	 viewControllerBeforeViewController:(UIViewController *)viewController {
	// 從 page content array 取出目前 VC 的 index
	NSUInteger currentIndex = [self.pageviewContentVCs indexOfObject:viewController];
	// 不是第一頁就傳回上一頁
	if (currentIndex > 0) {
		return [self.pageviewContentVCs objectAtIndex:currentIndex-1];
	} else {
		return nil;
	}
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerAfterViewController:(UIViewController *)viewController {
	NSUInteger currentIndex = [self.pageviewContentVCs indexOfObject:viewController];
	// 不是最後一頁就傳回下一頁
	if (currentIndex < [self.pageviewContentVCs count]-1){
		return [self.pageviewContentVCs objectAtIndex:currentIndex+1];
	} else {
		return nil;
	}
}

/* 設置的話會有 page VC 原生的 page control
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
	return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
	return 0;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickMenu:(id)sender {
	
	UIViewController *maskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemMaskVC"];
	[self addChildViewController:maskVC];
	[self.view addSubview:maskVC.view];
	
}
@end
