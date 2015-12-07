//
//  iBGEXhPageParentViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/15.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGExhPageParentViewController.h"
#import "iBGExhInfoViewController.h"
#import "iBGCommentTableViewController.h"
#import "iBGMoniterViewController.h"

@interface iBGExhPageParentViewController ()

@end

@implementation iBGExhPageParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// show id
	NSLog(@"目前展覽 ID： %@", [self.exhInfo objectForKey:@"id"]);
    
	// 禁止 swipe back
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	[[self navigationController] setNavigationBarHidden:NO];
	
	// Create page view controller
	self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExhPageVC"];
	self.pageViewController.dataSource = self;
	//	self.pageViewController.delegate = self;
	
	iBGExhInfoViewController *iBGExhInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExhInfoVC"];
	iBGExhInfoViewController.exhInfo = self.exhInfo;
	iBGCommentTableViewController *iBGExhCommentTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemCommentTableVC"];
	iBGExhCommentTableViewController.commentType = @"exh";
	iBGExhCommentTableViewController.commentObjID = [self.exhInfo objectForKey:@"id"];
	iBGExhCommentTableViewController.commentObjTitle = [self.exhInfo objectForKey:@"title"];
	iBGExhCommentTableViewController.commentObjSubtitle = [self.exhInfo objectForKey:@"subtitle"];
	
	self.pageviewContentVCs = @[iBGExhInfoViewController, iBGExhCommentTableViewController];
	[self.pageViewController setViewControllers:@[iBGExhInfoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	self.exhPageControl.numberOfPages = 2;

	
	// 把 page VC 塞給目前的 VC
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
	
	// 把固定顯示的物件拉到最前面
	[self.view bringSubviewToFront:self.enterExhBtn];
}

- (void)viewWillAppear:(BOOL)animated {
	
    // 設定 nav bar item，標題下面放 page control
	self.exhPageControl = [[UIPageControl alloc] init];
	self.exhPageControl.frame = (CGRect){0, 25, 320, 20};
	self.exhPageControl.numberOfPages = 2;
	self.exhPageControl.currentPage = 0;
	
	self.navTitleLabel = [[UILabel alloc] initWithFrame:(CGRect){0, -5, 320, 40}];
	self.navTitleLabel.textColor = [UIColor whiteColor];
	self.navTitleLabel.font = [self.navTitleLabel.font fontWithSize:18];
	self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
	self.navTitleLabel.text = [self.exhInfo objectForKey:@"title"];
	
	[self.navigationController.navigationBar addSubview:self.navTitleLabel];
	[self.navigationController.navigationBar addSubview:self.exhPageControl];
}

-(void)viewWillDisappear:(BOOL)animated {
	[self.navTitleLabel removeFromSuperview];
	[self.exhPageControl removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickStartGuide:(id)sender {
	NSUInteger ownIndex = [self.navigationController.viewControllers indexOfObject:self];
	iBGMoniterViewController *moniterVC = (iBGMoniterViewController *)[self.navigationController.viewControllers objectAtIndex:ownIndex - 1];
	[moniterVC setValue:[self.exhInfo objectForKey:@"id"] forKeyPath:@"exhID"];
	[moniterVC setValue:[self.exhInfo objectForKey:@"title"] forKeyPath:@"exhTitle"];
	[moniterVC setValue:moniterVC.objData forKeyPath:@"exhInfo"];
	
	
	
	// 有路線則去路線頁面
	if () {
		NSString *urlString = [NSString stringWithFormat:@"%@/get_iBeacon_link_obj/%@/%@/%@", kWebAPIRoot, beaconRegion.proximityUUID.UUIDString, beaconRegion.major, beaconRegion.minor];
		NSURL *url = [NSURL URLWithString: urlString];
		NSError *dataError, *jsonError;
		NSData *data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&dataError];
		NSLog(@"URL: %@", urlString);
		if (dataError) {
			NSLog(@"dataError: %@",[dataError localizedDescription]);
			return NO;
		}
		
		NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
		if (jsonError) {
			NSLog(@"jsonError: %@",[jsonError localizedDescription]);
			return NO;
		}
		
		[self performSegueWithIdentifier:@"ExhToRoute" sender:self];
	// 沒有路線直接回 moniter，把展覽物件存進 core data
	} else {
		[moniterVC saveExhCollectData];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
//	[self.navigationController popViewControllerAnimated:NO];
}

@end
