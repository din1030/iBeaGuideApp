//
//  iBGTopicCollectionViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/14.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGTopicCollectionViewController.h"
#import "iBGMoniterViewController.h"

#define kWebAPIRoot @"http://114.34.1.57/iBeaGuide/App"

@interface iBGTopicCollectionViewController ()

@end

@implementation iBGTopicCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Register cell classes
    // [self.topicCollectionView registerClass:[iBGTopicCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	
	// This is important. The normal deceleration rate would mean that swiping slowly would make the page snapping
	// animate slowly, which isn't how the default paging works. Fast deceleration makes the pages snap just like
	// they would in if you turned on paging.
	
	self.topicCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
	
//	self.topicList = [NSMutableArray array];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickTopicCheckBtn:(UIButton *)sender {
	
	NSUInteger ownIndex = [self.navigationController.viewControllers indexOfObject:self];
	iBGMoniterViewController *moniterVC = (iBGMoniterViewController *)[self.navigationController.viewControllers objectAtIndex:ownIndex - 2];
	moniterVC.topicID = sender.tag;
	moniterVC.topicItems = [self getTopicItems:(int)sender.tag];
	[moniterVC saveExhCollectData];
	
	[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:ownIndex - 2] animated:YES];
	
}

- (NSArray *)getTopicItems:(int)topicID {
	
	NSString *urlString = [NSString stringWithFormat:@"%@/get_in_topic_items/%d", kWebAPIRoot, topicID];
	NSURL *url = [NSURL URLWithString: urlString];
	NSError *dataError, *jsonError;
	NSData *data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&dataError];
	NSLog(@"URL: %@", urlString);
	if (dataError) {
		NSLog(@"dataError: \n UserInfo => %@ \n Description => %@",[dataError userInfo], [dataError localizedDescription]);
		return nil;
	}
	
	NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
	if (jsonError) {
		NSLog(@"jsonError: \n UserInfo => %@ \n Description => %@",[jsonError userInfo], [jsonError localizedDescription]);
		return nil;
	}
	
	return result;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	// puls 1 for topic with all item
	return [self.topicList count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	iBGTopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopicCell" forIndexPath:indexPath];
	cell.layer.cornerRadius = 5.0;
	CALayer *inputLayer = [[iBGTextInputLayer alloc] init];
	inputLayer.frame = cell.bounds;
	[cell.layer addSublayer:inputLayer];
	
	if (indexPath.row == 0) {
		
		cell.topicID = 0;
		cell.topicCheckBtn.tag = cell.topicID;
		cell.topicTitle.text = @"所有展品";
		[cell.topicMainPic setImage:[UIImage imageNamed:@"dct.jpg"]];
		[cell.topicMainPic setContentMode:UIViewContentModeScaleAspectFit];
		cell.topicDescription.text = @"顯示所有具有導覽資訊的展品。";
		
	} else {
	
		NSDictionary *topicInfo = self.topicList[indexPath.row - 1];
		cell.topicID = [[topicInfo objectForKey:@"id"] integerValue];
		cell.topicCheckBtn.tag = cell.topicID;
		NSLog(@"cell.topicCheckBtn.tag = %ld", (long)cell.topicCheckBtn.tag);
		cell.topicTitle.text = [topicInfo objectForKey:@"title"];
		[cell.topicMainPic setContentMode:UIViewContentModeScaleAspectFit];
		[cell.topicMainPic setImage:[self urlStringToImage:[NSString stringWithFormat:@"http://114.34.1.57/iBeaGuide/user_uploads/user_1/topic_%@.jpg", [topicInfo objectForKey:@"id"]]]];
		cell.topicDescription.text = [topicInfo objectForKey:@"description"];

	}
	
	return cell;
}

- (UIImage *)urlStringToImage:(NSString *)urlString {
	
	NSURL *url =  [NSURL URLWithString: urlString];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *urlImage = [UIImage imageWithData:data];
	
	return urlImage;
}

#pragma mark <UICollectionViewDelegate>

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	// Get the size of the page, adjusting for the content insets.
	CGRect insetFrame = UIEdgeInsetsInsetRect( self.topicCollectionView.frame, self.topicCollectionView.contentInset );
//	NSLog(@"insetFrame.size.width = %f", insetFrame.size.width);
	
	// Determine the page index to fall on based on scroll position.
	CGFloat pageIndex = self.topicCollectionView.contentOffset.x / insetFrame.size.width;
	
	// Going forward, we round to the next page.
	if( velocity.x > 0 ) {
		pageIndex = ceilf( pageIndex );
	}
	
	// Round to the closest page if we have no velocity.
	else if( velocity.x == 0 ) {
		pageIndex = roundf( pageIndex );
	}
	
	// Round to the previous page (odds are, we're going backwards).
	else {
		pageIndex = floorf( pageIndex );
	}
	
	// This is likely our new offset
	CGFloat newOffset = ( pageIndex * insetFrame.size.width );
	
	// If we don't have enough for a full page at the end, snap to the end point.
	// This means the penultimate page will have some content crossover with the
	// last page, and mirrors the default paging behaviour.
	if( newOffset > self.topicCollectionView.contentSize.width - insetFrame.size.width ) {
		newOffset = self.topicCollectionView.contentSize.width - insetFrame.size.width;
	}
	
	// Set our target content offset.
	// We multiply the target page index by the page width, and adjust for the content inset.
	targetContentOffset->x = newOffset - self.topicCollectionView.contentInset.left;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
