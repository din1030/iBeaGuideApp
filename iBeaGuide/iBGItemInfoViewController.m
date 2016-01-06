//
//  iBGItemInfoViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemInfoViewController.h"
#import "UILabel+AutoHeight.h"

@interface iBGItemInfoViewController ()

@end

@implementation iBGItemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// 將資料傳給 label
	self.itemTitle.text = [self.itemInfo objectForKey:@"title"];
    self.itemSubtitle.text = [self.itemInfo objectForKey:@"subtitle"];
    self.itemCreator.text = [self.itemInfo objectForKey:@"creator"];
    self.itemFinishedTimeValue.text = [self.itemInfo objectForKey:@"work_time"];
    [self.itemFinishedTimeValue autoHeight];
    self.itemBrief.text = [self.itemInfo objectForKey:@"brief"];
    [self.itemBrief autoHeight];
    
	NSMutableArray *basicFields;
	
	// 抓取客製欄位
	if (![self.callerPage isEqualToString:@"myCollection"]) {
		basicFields = [NSMutableArray arrayWithArray:[self.itemInfo objectForKey:@"basic_field"]];
	} else {
		// 要從有relationship 的欄位找出要的 type
		basicFields = [NSMutableArray array];
		for (NSDictionary *field in [self.itemInfo objectForKey:@"hasFields"]) {
			if ([[field valueForKey:@"type"] isEqualToString:@"basic"]) {
				[basicFields addObject:field];
			}
		}
	}
    
//    int realFieldCount = (int)[basicFields count];
    
    CGRect refNameFrame = self.itemFinishedTimeLabel.frame;
    CGRect refValueFrame = self.itemFinishedTimeValue.frame;
    int i;
    for (i = 0; i < [basicFields count]; i++) {
        
        UILabel *curNameLabel = [[UILabel alloc] init];
        curNameLabel.text =  [NSString stringWithFormat:@"%@：", basicFields[i][@"field_name"]];
        curNameLabel.frame = (CGRect){refNameFrame.origin.x, refNameFrame.origin.y + refValueFrame.size.height + 10, curNameLabel.intrinsicContentSize.width, refNameFrame.size.height};
        
        UILabel *curValueLabel = [[UILabel alloc] init];
        curValueLabel.text = basicFields[i][@"field_value"];
        curValueLabel.frame = (CGRect){curNameLabel.frame.origin.x + curNameLabel.frame.size.width, curNameLabel.frame.origin.y , self.view.frame.size.width - 50 - curNameLabel.frame.size.width, refNameFrame.size.height};
        [curValueLabel autoHeight];
        [self.itemInfoScrollView addSubview:curNameLabel];
        [self.itemInfoScrollView addSubview:curValueLabel];
        
        refNameFrame = curNameLabel.frame;
        refValueFrame = curValueLabel.frame;
    
    }
    self.itemBrief.frame = (CGRect){refNameFrame.origin.x, refNameFrame.origin.y + refValueFrame.size.height + 10, self.itemBrief.frame.size.width, self.itemBrief.frame.size.height};
    
	// (根據圖片數量)先塞空的 iBGNYTPhoto obj，才會有 loading view。
	self.photos = [NSArray arrayWithObjects:[iBGNYTPhoto new], [iBGNYTPhoto new], [iBGNYTPhoto new], nil];
	self.photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos];
	self.photosViewController.delegate = self;
	
	[[self.itemInfoPicBtn imageView] setContentMode:UIViewContentModeScaleAspectFit];
//	[self.itemInfoPicBtn setImage:[UIImage imageNamed:@"Sanpan.jpg"] forState:UIControlStateNormal];

	// 取 scrollview 所有 subview 的 frame 的聯集
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.itemInfoScrollView.subviews) {
		// 最後的捲軸 UIImageView 固定是 568 所以不要去算他
		if (![view isKindOfClass:[UIImageView class]]) {
			contentRect = CGRectUnion(contentRect, view.frame);
		}
	}
	
	// 增加與底部按鈕距離
	contentRect.size.height += 30.0;
	self.itemInfoScrollView.contentSize = contentRect.size;
	
	// 在背景 load 圖片
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
#warning Link real pic
		
		
		// 從 url 取得圖片
		UIImage *image1 = [self urlStringToImage:[NSString stringWithFormat:@"http://114.34.1.57/iBeaGuide/user_uploads/user_1/item_%@_main.jpg", [self.itemInfo objectForKey:@"id"]]];
		self.itemPicArray = [NSMutableArray arrayWithObjects:image1, nil];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.itemInfoPicBtn setImage:image1 forState:UIControlStateNormal];
		});
		
		
		// 把圖片給 iBGNYTPhoto obj
		for (int i = 0; i < [self.itemPicArray count]; i++) {
			
//			iBGNYTPhoto *photo = self.photos[i];
//			photo.image = self.itemPicArray[i];
			
//			photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//			photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:self.itemTitle.text attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
//			photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"照片說明" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
		}
		// 回到 main queue 更新 UI (圖片)
		dispatch_async(dispatch_get_main_queue(), ^{
			
			for (int i = 0; i < [self.itemPicArray count]; i++) {
				NSLog(@"Item Info / update Image For Photo %d", i);
				iBGNYTPhoto *photo = self.photos[i];
				photo.image = self.itemPicArray[i];
				photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:[self.itemInfo objectForKey:@"title"] attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
				[self.photosViewController updateImageForPhoto:photo];
				[self.photosViewController updateOverlayInformation];
			}
		});
	});
}

- (void)viewDidAppear:(BOOL)animated {
	// 控制 page control 到對應位置
	iBGItemPageParentViewController *pageParentVC = (iBGItemPageParentViewController*)self.parentViewController.parentViewController;
	pageParentVC.itemPageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UIImage *)urlStringToImage:(NSString *)urlString {
	
	NSURL *url =  [NSURL URLWithString: urlString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *urlImage = [UIImage imageWithData:data];
	
	return urlImage;
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
	return self.itemInfoPicBtn;
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
	
	[segue destinationViewController].navigationItem.title = self.navigationItem.title;

}

@end
