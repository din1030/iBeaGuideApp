//
//  iBGCollectionPageParentViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/8.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGCollectionPageParentViewController.h"
#import "iBGMyCollectionTableViewController.h"

@interface iBGCollectionPageParentViewController ()

@end

@implementation iBGCollectionPageParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	// 禁止 swipe back
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	
	self.exhInMyCollection = [NSArray array];
	self.exhInMyCollection = [NSArray arrayWithObjects:@"A", @"A", @"A", @"A", nil];
	
	if ([self.exhInMyCollection count] == 0) {
		self.collectionPageControlBG.hidden = YES;
		self.collectionPageControl.hidden = YES;
	} else {
		self.noRecordLabel.hidden = YES;
		self.collectionPageControl.numberOfPages = [self.exhInMyCollection count];
		// Create page view controller
		self.collectionPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionPageVC"];
		self.collectionPageViewController.dataSource = self;
		//	self.collectionPageViewController.delegate = self;
		
		// Change the size of page view controller
		//	self.collectionPageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
		
		iBGMyCollectionTableViewController *startingViewController = [self viewControllerAtIndex:0];
		[self.collectionPageViewController setViewControllers:@[startingViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
		
		[self addChildViewController:self.collectionPageViewController];
		[self.view addSubview:self.collectionPageViewController.view];
		[self.collectionPageViewController didMoveToParentViewController:self];
		
		// 把固定顯示的物件拉到最前面
		[self.view bringSubviewToFront:self.collectionPageControlBG];
		[self.view bringSubviewToFront:self.collectionPageControl];
	}
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	NSUInteger currentIndex = ((iBGMyCollectionTableViewController*) viewController).pageIndex;
	
	if ((currentIndex == 0) || (currentIndex == NSNotFound)) {
		return nil;
	}
	
	return [self viewControllerAtIndex:currentIndex-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger currentIndex = ((iBGMyCollectionTableViewController*) viewController).pageIndex;
	
	if (currentIndex == NSNotFound) {
		return nil;
	}
	
	if (currentIndex == [self.exhInMyCollection count] - 1) {
		return nil;
	}
	return [self viewControllerAtIndex:currentIndex+1];
}

- (iBGMyCollectionTableViewController *)viewControllerAtIndex:(NSUInteger)index
{
	if (([self.exhInMyCollection count] == 0) || (index >= [self.exhInMyCollection count])) {
		return nil;
	}
	
	// Create a new view controller and pass suitable data.
	iBGMyCollectionTableViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionExhWithItemList"];
	pageContentViewController.pageIndex = index;
	
	return pageContentViewController;
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
