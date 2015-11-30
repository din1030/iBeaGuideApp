//
//  iBGRouteCollectionViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/14.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGRouteCollectionViewController.h"
#import "iBGMoniterViewController.h"

@interface iBGRouteCollectionViewController ()

@end

@implementation iBGRouteCollectionViewController

static NSString * const reuseIdentifier = @"RouteCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Register cell classes
    // [self.routeCollectionView registerClass:[iBGRouteCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
	
	// This is important. The normal deceleration rate would mean that swiping slowly would make the page snapping
	// animate slowly, which isn't how the default paging works. Fast deceleration makes the pages snap just like
	// they would in if you turned on paging.
	
	self.routeCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
	
//	self.routeList = [NSMutableArray array];
	self.routeList = [NSMutableArray arrayWithObjects:@"routeA", @"routeB", @"routeC", @"routeD", nil];
	
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



- (IBAction)clickRouteCheckBtn:(UIButton *)sender {
	
	NSUInteger ownIndex = [self.navigationController.viewControllers indexOfObject:self];
	iBGMoniterViewController *moniterVC = (iBGMoniterViewController *)[self.navigationController.viewControllers objectAtIndex:ownIndex - 2];
	moniterVC.routeID = sender.tag;
	[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:ownIndex - 2] animated:YES];
	
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.routeList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	iBGRouteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	cell.layer.cornerRadius = 5.0;
	CALayer *inputLayer = [[iBGTextInputLayer alloc] init];
	inputLayer.frame = cell.bounds;
	[cell.layer addSublayer:inputLayer];
	
	cell.routeID = indexPath.row;
	cell.routeCheckBtn.tag = cell.routeID;
	cell.routeTitle.text = [NSString stringWithFormat:@"精選路線 %ld", (long)cell.routeID];
	[cell.routeMainPic setImage:[UIImage imageNamed:@"Sanpan.jpg"]];
	cell.routeDescription.text = @"精選路線說明";

	return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	// Get the size of the page, adjusting for the content insets.
	CGRect insetFrame = UIEdgeInsetsInsetRect( self.routeCollectionView.frame, self.routeCollectionView.contentInset );
//	NSLog(@"insetFrame.size.width = %f", insetFrame.size.width);
	
	// Determine the page index to fall on based on scroll position.
	CGFloat pageIndex = self.routeCollectionView.contentOffset.x / insetFrame.size.width;
	
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
	if( newOffset > self.routeCollectionView.contentSize.width - insetFrame.size.width ) {
		newOffset = self.routeCollectionView.contentSize.width - insetFrame.size.width;
	}
	
	// Set our target content offset.
	// We multiply the target page index by the page width, and adjust for the content inset.
	targetContentOffset->x = newOffset - self.routeCollectionView.contentInset.left;
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
