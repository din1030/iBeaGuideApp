//
//  iBGItemDetailViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemDetailViewController.h"

static const NSUInteger NYTViewControllerCustomEverythingPhotoIndex = 1;
static const NSUInteger NYTViewControllerDefaultLoadingSpinnerPhotoIndex = 3;
static const NSUInteger NYTViewControllerNoReferenceViewPhotoIndex = 4;
static const NSUInteger NYTViewControllerCustomMaxZoomScalePhotoIndex = 5;

@interface iBGItemDetailViewController ()

@end

@implementation iBGItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//	iBGItemPageParentViewController *pageParentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pageContainerVC"];
//	pageParentVC.itemPageControl.currentPage = 1;
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

- (IBAction)imageButtonTapped:(id)sender {
	self.photos = [[self class] newTestPhotos];
	
	NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:self.photos];
	photosViewController.delegate = self;
	[self presentViewController:photosViewController animated:YES completion:nil];
	
	[self updateImagesOnPhotosViewController:photosViewController afterDelayWithPhotos:self.photos];
}

// This method simulates previously blank photos loading their images after some time.
- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
	CGFloat updateImageDelay = 5.0;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		for (iBGNYTPhoto *photo in photos) {
			if (!photo.image) {
				// Photo credit: Nic Lehoux
				photo.image = [UIImage imageNamed:@"NYTimesBuilding"];
				[photosViewController updateImageForPhoto:photo];
			}
		}
	});
}

+ (NSArray *)newTestPhotos {
	NSMutableArray *photos = [NSMutableArray array];
	
	NSURL *url = [NSURL URLWithString: @"http://140.119.189.154/iBeaGuide/user_uploads/User_1/User_1_exh_1.jpg"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image1 = [UIImage imageWithData:data];

	url = [NSURL URLWithString: @"http://140.119.189.154/iBeaGuide/user_uploads/User_1/User_1_exh_2.jpg"];
	data = [NSData dataWithContentsOfURL:url];
	UIImage *image2 = [UIImage imageWithData:data];
	
	
	NSMutableArray *photoImg = [NSMutableArray arrayWithObjects:image1, image2, image1, image2, image1, image2, nil];
	
	for (int i = 0; i < 6; i++) {
		iBGNYTPhoto *photo = [[iBGNYTPhoto alloc] init];
		
		photo.image = [photoImg objectAtIndex:i];
		
		if (i == NYTViewControllerCustomEverythingPhotoIndex || i == NYTViewControllerDefaultLoadingSpinnerPhotoIndex) {
			photo.image = nil;
		}
		
		if (i == NYTViewControllerCustomEverythingPhotoIndex) {
			photo.placeholderImage = [UIImage imageNamed:@"NYTimesBuildingPlaceholder"];
		}
		
//		photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString:@(i + 1).stringValue attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
		photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:@"展品名稱" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
		photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"照片說明" attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
		[photos addObject:photo];
	}
	
	return photos;
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
	if ([photo isEqual:self.photos[NYTViewControllerNoReferenceViewPhotoIndex]]) {
		return nil;
	}
	
	return self.imageButton;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController loadingViewForPhoto:(id <NYTPhoto>)photo {
	if ([photo isEqual:self.photos[NYTViewControllerCustomEverythingPhotoIndex]]) {
		UILabel *loadingLabel = [[UILabel alloc] init];
		loadingLabel.text = @"Custom Loading...";
		loadingLabel.textColor = [UIColor greenColor];
		return loadingLabel;
	}
	
	return nil;
}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo {
	if ([photo isEqual:self.photos[NYTViewControllerCustomEverythingPhotoIndex]]) {
		UILabel *label = [[UILabel alloc] init];
		label.text = @"Custom Caption View";
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor redColor];
		return label;
	}
	
	return nil;
}

- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController maximumZoomScaleForPhoto:(id <NYTPhoto>)photo {
	if ([photo isEqual:self.photos[NYTViewControllerCustomMaxZoomScalePhotoIndex]]) {
		return 10.0f;
	}
	
	return 1.0f;
}

- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo {
	if ([photo isEqual:self.photos[NYTViewControllerCustomEverythingPhotoIndex]]) {
		return @{NSForegroundColorAttributeName: [UIColor grayColor]};
	}
	
	return nil;
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didNavigateToPhoto:(id <NYTPhoto>)photo atIndex:(NSUInteger)photoIndex {
	NSLog(@"Did Navigate To Photo: %@ identifier: %lu", photo, (unsigned long)photoIndex);
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
