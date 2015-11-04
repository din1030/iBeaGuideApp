//
//  iBGItemPageViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemPageViewController.h"
#import "iBGItemInfoViewController.h"
#import "iBGItemDetailViewController.h"
#import "iBGItemCommentViewController.h"

@interface iBGItemPageViewController ()

@end

@implementation iBGItemPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	iBGItemInfoViewController *iBGItemInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemInfoVC"];
	iBGItemDetailViewController *iBGItemDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailVC"];
	iBGItemCommentViewController *iBGItemCommentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemCommentVC"];
	self.pageviewContentVCs = @[iBGItemInfoViewController, iBGItemDetailViewController, iBGItemCommentViewController];
	NSArray *startingItemVC= @[iBGItemInfoViewController];
	
	// Create page view controller
	self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemPageVC"];
	self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;
	
	[self.pageViewController setViewControllers:startingItemVC direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
	
	[self.view bringSubviewToFront:self.itemPageControl];
	[self.view insertSubview:self.itemPageControlBG belowSubview:self.itemPageControl];
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
	
}

- (void)pageViewController:(UIPageViewController *)pageViewController
		didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
	   transitionCompleted:(BOOL)completed {
	
	if (completed) {
//		self.itemPageControl.currentPage = [self.pageviewContentVCs indexOfObject:[previousViewControllers objectAtIndex:0]] + 1;
	}
	
}

#pragma mark - Page View Controller Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	 viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSUInteger currentIndex = [self.pageviewContentVCs indexOfObject:viewController];
	// get the index of the current view controller on display
	
	if (currentIndex > 0)
	{
//		self.itemPageControl.currentPage = currentIndex-1;
		return [self.pageviewContentVCs objectAtIndex:currentIndex-1];
		// return the previous viewcontroller
	} else
	{
		return nil;
		// do nothing
	}
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger currentIndex = [self.pageviewContentVCs indexOfObject:viewController];
	// get the index of the current view controller on display
	// check if we are at the end and decide if we need to present
	// the next viewcontroller
	if (currentIndex < [self.pageviewContentVCs count]-1)
	{
//		self.itemPageControl.currentPage = currentIndex+1;
		return [self.pageviewContentVCs objectAtIndex:currentIndex+1];
		// return the next view controller
	} else
	{
		return nil;
		// do nothing
	}
}


//- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
//{
//	return 3;
//}
//
//- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
//{
//	return 0;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
