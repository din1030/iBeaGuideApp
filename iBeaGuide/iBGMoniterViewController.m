//
//  iBGMoniterViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/10/27.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGMoniterViewController.h"

@interface iBGMoniterViewController ()

@end

@implementation iBGMoniterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //target-action
    [self.moniterButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *animationImg = [NSMutableArray arrayWithObjects:
                                    [UIImage imageNamed:@"detect_1.png"],
                                    [UIImage imageNamed:@"detect_2.png"],
                                    [UIImage imageNamed:@"detect_3.png"], nil];
    [self.moniterAnimation setAnimationImages: animationImg];
    [self.moniterAnimation setAnimationDuration: 1.5];
    //    [self.moniterAnimation setAnimationRepeatCount:20];
    [self.moniterAnimation startAnimating];
	
	UIImage *moniterImg = [[UIImage imageNamed:@"guide_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *moniterSelectedImg = [[UIImage imageNamed:@"guide_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *collectImg = [[UIImage imageNamed:@"collection_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *collectSelectedImg = [[UIImage imageNamed:@"collection_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *settingImg = [[UIImage imageNamed:@"setting_1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *settingSelectedImg = [[UIImage imageNamed:@"setting_2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	
	UITabBar *tabBar = self.tabBarController.tabBar;
	
	UITabBarItem *moniterItem = [tabBar.items objectAtIndex:0];
	UITabBarItem *collectItem = [tabBar.items objectAtIndex:1];
	UITabBarItem *settingItem = [tabBar.items objectAtIndex:2];
	
//	[moniterItem setTitle:@"導覽"];
	[moniterItem setImage:moniterImg];
	[moniterItem setSelectedImage:moniterSelectedImg];
	[collectItem setImage:collectImg];
	[collectItem setSelectedImage:collectSelectedImg];
	[settingItem setImage:settingImg];
	[settingItem setSelectedImage:settingSelectedImg];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)click:(id)sender {
    
    //    UIButton *button = sender;
    //    從UIEvent中取得UITouch物件
    //    UITouch *fingerTouch =  [event.allTouches anyObject];
    //    取得觸碰座標
    //    CGPoint touchPoint =  [fingerTouch locationInView:self.view];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"哈囉～"
                                                                             message:@"偵測到「聆．感．指南」展覽資訊，是否開始導覽？"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"開始" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier: @"moniter" sender: self];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
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
