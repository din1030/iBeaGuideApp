//
//  iBGItemPageParentViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGGlobalData.h"
#import "iBGItemPageParentViewController.h"
#import "iBGItemInfoViewController.h"
#import "iBGItemDetailViewController.h"
#import "iBGCommentTableViewController.h"
#import "iBGItemMaskViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>

@interface iBGItemPageParentViewController () <AVAudioPlayerDelegate>

@property AVAudioPlayer *theAudio;
@property AVAudioPlayer *theAudio2;

@end

@implementation iBGItemPageParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// show id
	NSLog(@"目前展品 ID： %@", [self.itemInfo objectForKey:@"id"]);
//    self.navigationItem.title = @"";
	
	// 禁止 swipe back
	self.navigationController.interactivePopGestureRecognizer.enabled = NO;
	[[self navigationController] setNavigationBarHidden:NO];
	
	// Create page view controller
	self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemPageVC"];
	self.pageViewController.dataSource = self;
	//	self.pageViewController.delegate = self;
	
	iBGItemInfoViewController *iBGItemInfoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemInfoVC"];
	iBGItemInfoViewController.itemInfo = self.itemInfo;
	iBGItemInfoViewController.callerPage = self.callerPage;
	iBGItemDetailViewController *iBGItemDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemDetailVC"];
	iBGItemDetailViewController.itemInfo = self.itemInfo;
	iBGItemDetailViewController.callerPage = self.callerPage;
	self.pageviewContentVCs = @[iBGItemInfoViewController, iBGItemDetailViewController];
	
	if (![self.callerPage isEqualToString:@"myCollection"]) {

		// 建立 page view 的 child VC (item 的 comment 頁面)
		iBGCommentTableViewController *iBGCommentTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemCommentTableVC"];
		iBGCommentTableViewController.commentType = @"item";
		iBGCommentTableViewController.commentObjID = [self.itemInfo objectForKey:@"id"];
		iBGCommentTableViewController.commentObjTitle = [self.itemInfo objectForKey:@"title"];
		iBGCommentTableViewController.commentObjSubtitle = [self.itemInfo objectForKey:@"subtitle"];
		
		NSLog(@"%@ %@", [self.itemInfo objectForKey:@"title"], [self.itemInfo objectForKey:@"subtitle"]);
		
		self.pageviewContentVCs = @[iBGItemInfoViewController, iBGItemDetailViewController, iBGCommentTableViewController];
	
	}
	
	[self.pageViewController setViewControllers:@[iBGItemInfoViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	self.itemPageControl.numberOfPages = [self.pageviewContentVCs count];
	
	// 把 page VC 塞給目前的 VC	
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
	
	// 把固定顯示的物件拉到最前面
	[self.view bringSubviewToFront:self.itemPageControlBG];
	[self.view bringSubviewToFront:self.itemPageControl];
	if (![self.callerPage isEqualToString:@"myCollection"]) {
		[self.view bringSubviewToFront:self.itemMenuBtn];
	} else {
		self.itemMenuBtn.hidden = YES;
	}
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"soda" ofType:@"mp3"];
	self.theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
	self.theAudio.delegate = self;
	
	path = [[NSBundle mainBundle] pathForResource:@"soda" ofType:@"mp3"];
	self.theAudio2 = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
	self.theAudio2.delegate = self;
	
	// 設定 category 讓聲音從 聽筒 播放
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
	
	NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
	for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
		if ([portDescription.portType isEqual:AVAudioSessionPortHeadphones]) {
			NSLog(@"耳機連接中");
			[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
			if ([iBGGlobalData sharedInstance].autoPlayIsOn) {
				[self playAudioGuide];
			}
			break;
		}
	}
	
	// 啟動 proximity 偵測，設定狀態改變的行為
	[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
												 name:UIDeviceProximityStateDidChangeNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeAudioSessionRoute:)
												 name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
	if ([[UIDevice currentDevice] proximityState] == YES) {
		NSLog(@"Device is close to user.");
		[self playAudioGuide];
	} else {
		NSLog(@"Device is away from user.");
		[self pauseAudioGuide];
	}
}

- (void)didChangeAudioSessionRoute:(NSNotification *)notification
{
	NSLog(@"AVAudioSessionRoute has changed.");
	[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
	NSArray *availableOutputs = [[AVAudioSession sharedInstance] currentRoute].outputs;
	for (AVAudioSessionPortDescription *portDescription in availableOutputs) {
		if ([portDescription.portType isEqual:AVAudioSessionPortHeadphones]) {
			NSLog(@"耳機連接中");
			[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
			break;
		}
	}
	
}


- (void)viewDidAppear:(BOOL)animated {
	if ([iBGGlobalData sharedInstance].autoPlayIsOn) {
		[self playAudioGuide];
	}
}


- (void)viewDidDisappear:(BOOL)animated {
	[self stopAudioGuide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAudioGuide {
	
	[self.theAudio play];
//	[self.theAudio2 play];
	
//	//取得播放檔案的位置
//	NSURL *url = [NSURL URLWithString:@"http://FileName.mp3"];
//	NSData *myNetworkData = [NSData dataWithContentsOfURL:url];
// 
//	//與音樂檔案做連結
//	NSError* error = nil;
//	myPlayer = [[AVAudioPlayer alloc] initWithData:myNetworkData error:&error];
// 
//	if (!url || error) {
//		//錯誤處理常式
//	}
	
}

- (IBAction)stopAudioGuide {
	[self.theAudio stop];
}

- (IBAction)pauseAudioGuide {
	[self.theAudio pause];
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
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

- (IBAction)clickMenu:(id)sender {
	
	iBGItemMaskViewController *maskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemMaskVC"];
	maskVC.itemInfo = self.itemInfo;
	[self addChildViewController:maskVC];
	[self.view addSubview:maskVC.view];
	
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// 去留言頁面
	if ([segue.identifier isEqualToString:@"ItemComment"]) {
//		[segue destinationViewController].navigationItem.title = [self.itemInfo objectForKey:@"title"];
		[[segue destinationViewController] setValue:@"item" forKey:@"type"];
		[[segue destinationViewController] setValue:[self.itemInfo objectForKey:@"id"] forKey:@"objID"];
	}
}

@end
