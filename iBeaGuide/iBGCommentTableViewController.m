//
//  iBGCommentTableViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/6.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "UIView+Glow.h"
#import "MBProgressHUD.h"
#import "iBGCommentTableViewController.h"
#import "iBGCommentTableViewHeaderCell.h"
#import "iBGCommentTableViewCell.h"
#import "UILabel+AutoHeight.h"

#import "UITableView+FDTemplateLayoutCell.h"

#define kWebAPIRoot @"http://114.34.1.57/iBeaGuide/App"
#define kItemCommentHeaderHeight 58
#define kItemCommentCellHeight 176

@interface iBGCommentTableViewController () <MBProgressHUDDelegate>

@property iBGCommentTableViewCell *hCell;

@end

@implementation iBGCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	hud.delegate = self;
	hud.labelText = @"讀取留言中...";
	
	// Show the HUD while the provided method executes in a new thread
	[hud showWhileExecuting:@selector(loadTask) onTarget:self withObject:nil animated:YES];
	
	
	if ([self.commentType isEqualToString:@"exh"]) {
		self.exhPageParentVC = (iBGExhPageParentViewController*)self.parentViewController.parentViewController;
	} else {
		self.itemPageParentVC = (iBGItemPageParentViewController*)self.parentViewController.parentViewController;
	}
	
}

- (void)viewDidAppear:(BOOL)animated {
//	[self.tableView reloadData];
	// 控制 page control 到對應位置
	if ([self.commentType isEqualToString:@"exh"]) {
		self.exhPageParentVC.exhPageControl.currentPage = 1;
	} else {
		self.itemPageParentVC.itemPageControl.currentPage = 2;
		// 展品沒有留言的話閃爍按鈕
		// if ([self.commentArray count] == 0) {
			[self.itemPageParentVC.itemMenuBtn startGlowing];
		// }
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

- (void)loadTask {
	self.commentArray = [self getCommentData];
	[self.tableView reloadData];
}

- (NSArray *)getCommentData{
	
	NSString *urlString = [NSString stringWithFormat:@"%@/get_comment_data/%@/%@", kWebAPIRoot, self.commentType, self.commentObjID];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.commentArray count] > 0) {
		return [self.commentArray count] + 1; // plus 1 for header cell
	} else {
		return 2; // for header and "no comment" cell
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		
		iBGCommentTableViewHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCommentHeader" forIndexPath:indexPath];
		cell.title.text = self.commentObjTitle;
		cell.subtitle.text = self.commentObjSubtitle;
		return cell;
		
	} else {
		
		if ([self.commentArray count] > 0) {
			iBGCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemComment" forIndexPath:indexPath];
			
			// 塞資料給 cell
			NSDictionary *commentData = self.commentArray[indexPath.row - 1];
			cell.username.text = [commentData objectForKey:@"first_name"];
			cell.rate = [commentData objectForKey:@"rate"];
			cell.date.text = [commentData objectForKey:@"created"];
			cell.commentContent.text = [commentData objectForKey:@"content"];
			[cell.commentContent autoHeight];
			
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
		if ([self.commentArray count] > 0) {
			
			return [tableView fd_heightForCellWithIdentifier:@"ItemComment" cacheByIndexPath:indexPath configuration:^(iBGCommentTableViewCell *cell) {
				
				cell.fd_enforceFrameLayout = YES;
				// 塞資料給 cell
				NSDictionary *commentData = self.commentArray[indexPath.row - 1];
				cell.username.text = [commentData objectForKey:@"first_name"];
				cell.rate = [commentData objectForKey:@"rate"];
				cell.date.text = [commentData objectForKey:@"created"];
				cell.commentContent.text = [commentData objectForKey:@"content"];
				[cell.commentContent autoHeight];
			}];
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
