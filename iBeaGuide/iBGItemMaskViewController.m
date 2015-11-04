//
//  iBGItemMaskViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/4.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemMaskViewController.h"

@interface iBGItemMaskViewController ()

@end

@implementation iBGItemMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tapMaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMaskView)];
	[self.itemMaskView addGestureRecognizer:self.tapMaskView];
	
    // Do any additional setup after loading the view.
	
}

- (void)removeMaskView {
	NSLog(@"remove");
	self.msgBtn.enabled = false;
	self.addBtn.enabled = false;
	self.shareBtn.enabled = false;
	[UIView animateWithDuration:0.5f animations:^{
		[self.view setAlpha:0.0f];
	} completion:^(BOOL completion){
		[self.view removeFromSuperview];
	}];
	
	
//	[self removeFromParentViewController];
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

@end
