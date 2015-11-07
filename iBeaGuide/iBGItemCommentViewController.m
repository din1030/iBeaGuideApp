//
//  iBGItemCommentViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGItemCommentViewController.h"

@interface iBGItemCommentViewController ()

@end

@implementation iBGItemCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.tapDismissKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKB)];
	[self.view addGestureRecognizer:self.tapDismissKB];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
//	NSLog(@"self.view.frame.size.height: %f", self.view.frame.size.height);
	
}

- (void)keyboardWasShown:(NSNotification *)notification {
	
	NSDictionary *userInfo = [notification userInfo];
	NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [aValue CGRectValue];
	int height = keyboardRect.size.height;
	[self.commentScrollView setFrame:CGRectMake(0, 0, 320.0, self.view.frame.size.height - height)];
	NSLog(@"%f", self.view.frame.size.height - height);
	
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.commentScrollView.subviews) {
		contentRect = CGRectUnion(contentRect, view.frame);
	}
	[self.commentScrollView setContentSize:contentRect.size];

}

- (void)keyboardWillHide:(NSNotification *)notification {
	
	[self.commentScrollView setFrame:CGRectMake(0, 0, 320.0, self.view.frame.size.height)];
//	NSLog(@"%f", self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKB {
	[self.view endEditing:YES];
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
