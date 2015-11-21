//
//  iBGItemCommentTableViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/6.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "UIView+Glow.h"
#import "iBGItemCommentTableViewController.h"
#import "iBGCommentTableViewHeaderCell.h"
#import "iBGCommentTableViewCell.h"

#define kItemCommentHeaderHeight 58
#define kItemCommentCellHeight 176

@interface iBGItemCommentTableViewController ()

@end

@implementation iBGItemCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	// load true DB comments
	self.commentsOfItem = [NSMutableArray arrayWithObjects:@"A", @"A", @"A", @"A",nil];
//	self.commentsOfItem = [NSMutableArray array];
	if ([self.commentType isEqualToString:@"exh"]) {
		self.exhPageParentVC = (iBGExhPageParentViewController*)self.parentViewController.parentViewController;
	} else {
		self.itemPageParentVC = (iBGItemPageParentViewController*)self.parentViewController.parentViewController;
	}
	
	
	
}

- (void)viewDidAppear:(BOOL)animated {
	// 控制 page control 到對應位置
	if ([self.commentType isEqualToString:@"exh"]) {
		self.exhPageParentVC.exhPageControl.currentPage = 1;
	} else {
		self.itemPageParentVC.itemPageControl.currentPage = 2;
		if ([self.commentsOfItem count] == 0) {
			[self.itemPageParentVC.itemMenuBtn startGlowing];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([self.commentType isEqualToString:@"item"]) {
		if ([self.itemPageParentVC.itemMenuBtn glowView]) {
			[self.itemPageParentVC.itemMenuBtn stopGlowing];
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.commentsOfItem count] > 0) {
		return [self.commentsOfItem count] + 1; // plus 1 for header cell
	} else {
		return 2; // for header and "no comment" cell
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	UITableViewCell *cell;
	
	if (indexPath.row == 0) {
		
		iBGCommentTableViewHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCommentHeader" forIndexPath:indexPath];
		cell.title.text = self.commentObjTitle;
		cell.subtitle.text = self.commentObjSubtitle;
		
		return cell;
		
	} else {
		
		if ([self.commentsOfItem count] > 0) {
			iBGCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemComment" forIndexPath:indexPath];
			
			// 塞資料給 cell
			return cell;
		} else {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemNoComment" forIndexPath:indexPath];
		
			return cell;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		return kItemCommentHeaderHeight;
	} else {
		if ([self.commentsOfItem count] > 0) {
			return kItemCommentCellHeight;
		} else {
			return self.view.frame.size.height - kItemCommentHeaderHeight;
		}
	}
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
