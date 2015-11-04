//
//  AppDelegate.h
//  iBeaGuide
//
//  Created by din1030 on 2015/10/26.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "iBGItemMaskViewController.h"

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue, a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
				green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
				 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
				alpha:a]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

