//
//  iBGItemDetailViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemDetailViewController.h"

@interface iBGItemDetailViewController ()

@end

@implementation iBGItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// (根據圖片數量)先塞空的 iBGNYTPhoto obj，才會有 loading view。
	self.photos = [NSArray arrayWithObjects:[iBGNYTPhoto new], [iBGNYTPhoto new], [iBGNYTPhoto new], nil];
	self.photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos];
	self.photosViewController.delegate = self;
	
	[[self.imageButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
	[self.imageButton setImage:[UIImage imageNamed:@"Mona_Lisa.jpg"] forState:UIControlStateNormal];
	
	CGRect txtFrame = self.itemDetail.frame;
	txtFrame.size.height = [self.itemDetail.text boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
															  options: NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
														   attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.itemDetail.font,NSFontAttributeName, nil] context:nil].size.height;
	self.itemDetail.frame = txtFrame;
	
	// 取 scrollview 所有 subview 的 frame 的聯集
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.itemDetailScrollView.subviews) {
		// 最後的捲軸 UIImageView 固定是 568 所以不要去算他
		if (![view isKindOfClass:[UIImageView class]]) {
			contentRect = CGRectUnion(contentRect, view.frame);
		}
	}
	
	// 增加與底部按鈕距離
	contentRect.size.height += 30.0;
	self.itemDetailScrollView.contentSize = contentRect.size;
	
	// 在背景 load 圖片
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		// 從 url 取得圖片
		UIImage *image1 = [self urlStringToImage:@"https://placeimg.com/640/480/animals"];
		UIImage *image2 = [self urlStringToImage:@"https://placeimg.com/640/480/animals"];
		UIImage *image3 = [self urlStringToImage:@"https://placeimg.com/640/480/animals"];
		self.itemPicArray = [NSMutableArray arrayWithObjects:image1, image2, image3, nil];
		
		
		// 把圖片給 iBGNYTPhoto obj
		for (int i = 0; i < [self.itemPicArray count]; i++) {
			
			iBGNYTPhoto *photo = self.photos[i];
			photo.image = [self.itemPicArray objectAtIndex:i];
			
			//			photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
			photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:@"展品名稱" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
			photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"照片說明" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
		}
		// 回到 main queue 更新 UI (圖片)
		dispatch_async(dispatch_get_main_queue(), ^(void){
			
			for (int i = 0; i < [self.itemPicArray count]; i++) {
				NSLog(@"updateImageForPhoto");
				iBGNYTPhoto *photo = self.photos[i];
				photo.image = self.itemPicArray[i];
				[self.photosViewController updateImageForPhoto:photo];
				[self.photosViewController updateOverlayInformation];
			}
		});
	});

}

- (void)viewDidAppear:(BOOL)animated {
	// 控制 page control 到對應位置
	iBGItemPageParentViewController *pageParentVC = (iBGItemPageParentViewController*)self.parentViewController.parentViewController;
	pageParentVC.itemPageControl.currentPage = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
	return self.imageButton;
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
//	if ([photo isEqual:self.photos[NYTViewControllerCustomEverythingPhotoIndex]]) {
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
	
	return 5.0f;
}

//- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo {
//	
//	return nil;
//}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didDisplayPhoto:(id <NYTPhoto>)photo {
	NSLog(@"Did Display Photo: %@ identifier: %@", photo, @([self.photos indexOfObject:photo]).stringValue);
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType {
	NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
	NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
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
