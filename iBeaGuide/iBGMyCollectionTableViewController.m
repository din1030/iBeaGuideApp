//
//  iBGMyCollectionTableViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/7.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGMyCollectionTableViewController.h"
#import "iBGMyCollectionTableViewCell.h"

#define kItemHeaderHeight 250
#define kItemCellHeight 60

@interface iBGMyCollectionTableViewController ()

@end

@implementation iBGMyCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	
	// load real DB comments
//	 self.exhData = [NSMutableArray arrayWithObjects:@"A", @"A", @"A", @"A",nil];
//	self.exhData = [NSMutableArray array];
	
	self.collectPageParentVC = (iBGCollectionPageParentViewController*)self.parentViewController.parentViewController;
	
}
- (void)viewWillAppear:(BOOL)animated {
	[[self navigationController] setNavigationBarHidden:YES];
	// 取消選擇原本的項目
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	// 控制 page control 到對應位置
	self.collectPageParentVC.collectionPageControl.currentPage = self.pageIndex;
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
	
	// self.exhData should replace into collected item array!!
	return [self.itemData count] + 1; // plus 1 for header cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	// self.exhData should replace into collected item array!!
	if (indexPath.row == 0) {
		
		UITableViewCell *cell;
		cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionExhHeader" forIndexPath:indexPath];
		
		return cell;
	} else {
		
		iBGMyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionItem" forIndexPath:indexPath];
		cell.itemTitle.text = [[self.itemData objectAtIndex:indexPath.row - 1] valueForKey:@"title"];
		
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		return kItemHeaderHeight;
	} else {
		return kItemCellHeight;
	}
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	// fix for separators bug in iOS 7
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	// fix for separators bug in iOS 7
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	// Remove seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictly set your cell's layout margins
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//	iBGItemPageParentViewController *desVC = [segue destinationViewController];
	[[segue destinationViewController] setValue:@"collection" forKey:@"callerPage"];
}


@end
