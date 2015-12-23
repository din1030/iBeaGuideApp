//
//  iBGSectionInfoViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/15.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGSectionInfoViewController.h"

@interface iBGSectionInfoViewController ()

@property int secondsLeft;

@end

@implementation iBGSectionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// show id
	NSLog(@"目前展區 ID： %@", [self.prepareItemInfo objectForKey:@"sec_id"]);
	NSLog(@"即將顯示展品 ID： %@", [self.prepareItemInfo objectForKey:@"id"]);
	NSDictionary *secInfo = [self.prepareItemInfo objectForKey:@"sec_info"];
	self.secTitle.text = [secInfo objectForKey:@"title"];
	self.secDes.text = [secInfo objectForKey:@"description"];
	
	// (根據圖片數量)先塞空的 iBGNYTPhoto obj，才會有 loading view。
	self.photos = [NSArray arrayWithObjects:[iBGNYTPhoto new], [iBGNYTPhoto new], [iBGNYTPhoto new], nil];
	self.photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos];
	self.photosViewController.delegate = self;
	
	[[self.secMainPicBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.secMainPicBtn setImage:[UIImage imageNamed:@"Jade_Cabbage.jpg"] forState:UIControlStateNormal];

	CGRect txtFrame = self.secDes.frame;
	txtFrame.size.height = [self.secDes.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
															 options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
														  attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.secDes.font,NSFontAttributeName, nil] context:nil].size.height;
	self.secDes.frame = txtFrame;
	
	// 取 scrollview 所有 subview 的 frame 的聯集
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.secInfoScrollView.subviews) {
		// 最後的捲軸 UIImageView 固定是 568 所以不要去算他
		if (![view isKindOfClass:[UIImageView class]]) {
			contentRect = CGRectUnion(contentRect, view.frame);
		}
	}
	
	// 增加與底部按鈕距離
	contentRect.size.height += 10.0;
	self.secInfoScrollView.contentSize = contentRect.size;
	// 在背景 load 圖片
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		// 從 url 取得圖片
		UIImage *image1 = [self urlStringToImage:@"http://114.34.1.57/iBeaGuide/user_uploads/user_1/exh_1_sec_1.jpg"];
		UIImage *image2 = [self urlStringToImage:@"http://114.34.1.57/iBeaGuide/user_uploads/user_1/exh_3.jpg"];
		self.secPicArray = [NSMutableArray arrayWithObjects:image1, image2, nil];
		
		
		// 把圖片給 iBGNYTPhoto obj
		for (int i = 0; i < [self.secPicArray count]; i++) {
			
			iBGNYTPhoto *photo = self.photos[i];
			photo.image = [self.secPicArray objectAtIndex:i];
			
			//			photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
			photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:self.secTitle.text attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
			photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"照片說明" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
		}
		// 回到 main queue 更新 UI (圖片)
		dispatch_async(dispatch_get_main_queue(), ^(void){
			
			for (int i = 0; i < [self.secPicArray count]; i++) {
				NSLog(@"Section Info / update Image For Photo %d", i);
				iBGNYTPhoto *photo = self.photos[i];
				photo.image = self.secPicArray[i];
				[self.photosViewController updateImageForPhoto:photo];
				[self.photosViewController updateOverlayInformation];
			}
		});
	});
	
	// 設定倒數自動跳轉
	self.secondsLeft = 5;
	self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
//	[self.countDownTimer fire];
}

- (void)viewDidAppear:(BOOL)animated {
	if (!self.countDownTimer.isValid) {
		self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	if (self.countDownTimer.isValid) {
		[self.countDownTimer invalidate];
		self.countDownTimer = nil;
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)updateCounter:(NSTimer *)theTimer {
	if(self.secondsLeft > 0) {
		self.countDownLabel.text = [@(self.secondsLeft) stringValue];
		self.secondsLeft--;
	} else if (self.secondsLeft == 0){
		[self.countDownTimer invalidate];
		self.countDownTimer = nil;
		self.secondsLeft = 5;
		[self performSegueWithIdentifier:@"SecToItem" sender:self];
		self.countDownLabel.text = [@(self.secondsLeft) stringValue];
	}
}

- (IBAction)clickEnterBtn:(id)sender {

    [self performSegueWithIdentifier:@"SecToItem" sender:self];

}

- (UIImage *)urlStringToImage:(NSString *)urlString {
	
	NSURL *url =  [NSURL URLWithString: urlString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];
	
	return image;
}

#pragma mark - NYTPhotos

- (IBAction)imageButtonTapped:(id)sender {
	
	[self presentViewController:self.photosViewController animated:YES completion:nil];
	//	[self updateImagesOnPhotosViewController:self.photosViewController afterDelayWithPhotos:self.photos];
}

// 在設定時間還讀不到圖片就直接替換成指定圖片
- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
	CGFloat updateImageDelay = 5.0f;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		for (iBGNYTPhoto *photo in photos) {
			if (!photo.image) {
				// 替代圖片
				photo.image = [UIImage imageNamed:@"logo.png"];
				[photosViewController updateImageForPhoto:photo];
			}
		}
	});
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
	return self.secMainPicBtn;
}

// 客製化 loading
- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController loadingViewForPhoto:(id <NYTPhoto>)photo {
	
	NSLog(@"loadingViewForPhoto");
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
	UIView *loadingView = [[UIView alloc] initWithFrame:frame];
	
	UIActivityIndicatorView *loadingActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingActivityIndicatorView.center = loadingView.center;
	[loadingActivityIndicatorView startAnimating];
	
	UILabel *loadingLabel = [[UILabel alloc] initWithFrame:(CGRect){0, loadingView.center.y + 30, frame.size.width, 30}];
	[loadingView addSubview:loadingActivityIndicatorView];
	[loadingView addSubview:loadingLabel];
	loadingLabel.textAlignment = NSTextAlignmentCenter;
	loadingLabel.textColor = [UIColor lightGrayColor];
	loadingLabel.text = @"讀取圖片中...";
	
	return loadingView;
}

// 設定置底物件
//- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo {
//	if (YES) {
//		UILabel *label = [[UILabel alloc] init];
//		label.text = @"Custom Caption View";
//		label.textColor = [UIColor whiteColor];
//		label.backgroundColor = [UIColor redColor];
//		return label;
//	}
//
//	return nil;
//}

// 圖片可放大倍數
- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController maximumZoomScaleForPhoto:(id <NYTPhoto>)photo {
	
	NSLog(@"maximumZoomScaleForPhoto");
	return 5.0f;
}

// 改變 title 樣式
//- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo {
//
//	return @{NSForegroundColorAttributeName: [UIColor grayColor]};
////	return nil;
//}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didNavigateToPhoto:(id <NYTPhoto>)photo atIndex:(NSUInteger)photoIndex {
	NSLog(@"Did Navigate To Photo: %@ identifier: %lu", photo, (unsigned long)photoIndex);
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType {
	NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
	NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([[segue identifier] isEqualToString:@"SecToItem"]) {
		[segue destinationViewController].navigationItem.title = self.navigationItem.title;
		[[segue destinationViewController] setValue:self.prepareItemInfo forKey:@"itemInfo"];
	}
	
}

@end
