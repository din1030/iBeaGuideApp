//
//  iBGRouteCollectionViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/14.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGTextInputLayer.h"
#import "iBGRouteCollectionViewCell.h"

@interface iBGRouteCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *routeCollectionView;
@property (nonatomic) NSMutableArray *routeList;

@end
