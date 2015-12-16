//
//  iBGMyCollectionTableViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/11/7.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "AppDelegate.h"
#import "iBGMyCollectionTableViewController.h"
#import "iBGMyCollectionTableViewHeaderCell.h"
#import "iBGMyCollectionTableViewCell.h"

#define kItemHeaderHeight 250
#define kItemCellHeight 60

@interface iBGMyCollectionTableViewController ()

@property NSManagedObjectContext *context;

@end

@implementation iBGMyCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	
	// load real DB comments
//	 self.exhData = [NSMutableArray arrayWithObjects:@"A", @"A", @"A", @"A",nil];
//	self.exhData = [NSMutableArray array];
	
	self.collectPageParentVC = (iBGMyCollectionPageParentViewController*)self.parentViewController.parentViewController;

	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	self.context = [appDelegate managedObjectContext];

//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	NSEntityDescription *itemEntity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
//	[fetchRequest setEntity:itemEntity];
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY belongsExh = %@", [self.exhData objectID]];
//	[fetchRequest setPredicate:predicate];

//	NSError *error;
//	self.itemList = [self.context executeFetchRequest:fetchRequest error:&error];
//	if (self.itemList == nil) {
//		// Handle the error.
//		NSLog(@"NO ITEMS AVAILABLE");
//	}
	self.itemList = [self.exhInfo objectForKey:@"hasItems"];
	NSLog(@"itemList count: %lu", (unsigned long)[self.itemList count]);

}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
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
	return [self.itemList count] + 1; // plus 1 for header cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	// header cell 為展覽標題跟圖片，塞 MngObj
	if (indexPath.row == 0) {
		
		iBGMyCollectionTableViewHeaderCell *cell;
		cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionExhHeader" forIndexPath:indexPath];
		cell.exhInfo = self.exhInfo;
		cell.exhTitle.text = [self.exhInfo valueForKey:@"title"];

#warning Fill real pic

//		NSData *imgData = [NSData data];
//		cell.exhPic.image = [UIImage imageWithData:imgData];
		
		return cell;
	
	// 展品 cell 顯示標題然後把撈出來的 MngObj 塞進去，點選透過 obj 抓取 fields 再轉成 dictionary
	} else {
		
		iBGMyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionItem" forIndexPath:indexPath];
		cell.itemInfo = self.itemList[indexPath.row - 1];
		cell.itemTitle.text = [self.itemList[indexPath.row - 1] valueForKey:@"title"];
		
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
	
	[segue destinationViewController].navigationItem.title = [self.exhInfo valueForKey:@"title"];
	[[segue destinationViewController] setValue:@"myCollection" forKey:@"callerPage"];
	

	if ([segue.identifier isEqualToString:@"ShowCollectExh"]) {
		
		iBGMyCollectionTableViewHeaderCell *senderCell = (iBGMyCollectionTableViewHeaderCell *)sender;
		[[segue destinationViewController] setValue:senderCell.exhInfo forKey:@"exhInfo"];
		
	} else if ([segue.identifier isEqualToString:@"ShowCollectItem"]) {
		
		iBGMyCollectionTableViewCell *senderCell = (iBGMyCollectionTableViewCell *)sender;
		[[segue destinationViewController] setValue:senderCell.itemInfo forKey:@"itemInfo"];
		
	}
}


@end
