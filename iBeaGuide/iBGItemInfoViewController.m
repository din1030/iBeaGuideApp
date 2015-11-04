//
//  iBGItemInfoViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/2.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemInfoViewController.h"

@interface iBGItemInfoViewController ()

@end

@implementation iBGItemInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.pageVC = (iBGItemPageViewController*)self.parentViewController.parentViewController;
//	UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(235, 425, 60, 60)];
//	UIImage *menuImg = [UIImage imageNamed:@"message.png"];
//	[menuBtn setBackgroundImage:menuImg forState:UIControlStateNormal];
//	[self.view addSubview:menuBtn];
//	[self.view bringSubviewToFront:menuBtn];

}

- (void)viewDidAppear:(BOOL)animated {
	// 控制 page control 到對應位置
	self.pageVC.itemPageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickItemMenu:(id)sender {
	UIViewController *maskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemMaskVC"];
	[self addChildViewController:maskVC];
	[self.view addSubview:maskVC.view];
//	[self.view bringSubviewToFront:maskVC.view];
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
