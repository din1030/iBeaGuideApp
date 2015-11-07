//
//  iBGExhInfoViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/10/28.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGExhInfoViewController.h"
#import "iBGMoniterViewController.h"

@interface iBGExhInfoViewController ()

@end

@implementation iBGExhInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.exhNavItem.title = [self.exhInfo objectForKey:@"title"];
	self.exhDate.text = [NSString stringWithFormat:@"%@ ~ %@", [self.exhInfo objectForKey:@"start_date"], [self.exhInfo objectForKey:@"end_date"]];
	self.exhTime.text = [NSString stringWithFormat:@"%@ - %@", [self.exhInfo objectForKey:@"daily_open_time"], [self.exhInfo objectForKey:@"daily_close_time"]];
	self.exhVenue.text = [self.exhInfo objectForKey:@"venue"];
	self.exhSite.text = [self.exhInfo objectForKey:@"web_link"];
	self.exhDescription.text = [self.exhInfo objectForKey:@"description"];
	
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.exhScrollView.subviews) {
		contentRect = CGRectUnion(contentRect, view.frame);
	}
	contentRect.size.height += 60;
	self.exhScrollView.contentSize = contentRect.size;
	
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


- (IBAction)clickStartGuide:(id)sender {
	iBGMoniterViewController *iBGMoniterViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
	[iBGMoniterViewController setValue:[self.exhInfo objectForKey:@"id"] forKeyPath:@"exhID"];
//	iBGMoniterViewController.exhID = [[self.exhInfo objectForKey:@"id"] integerValue];
	[self.navigationController popViewControllerAnimated:NO];
}
@end
