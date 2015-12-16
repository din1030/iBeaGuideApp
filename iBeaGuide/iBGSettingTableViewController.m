//
//  iBGSettingTableViewController.m
//  iBeaGuide
//
//  Created by din1030 on 2015/12/8.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import "iBGGlobal.h"
#import "iBGGlobalData.h"
#import "iBGSettingTableViewController.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface iBGSettingTableViewController ()

@end

@implementation iBGSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
//     self.clearsSelectionOnViewWillAppear = YES;
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	// 抓 global data 判斷設備推播的設定
	self.facPushSwitch.on = [iBGGlobalData sharedInstance].facilityPushIsOn;
	[self.facPushSwitch addTarget:self action:@selector(changeFacPushSwitch:) forControlEvents:UIControlEventValueChanged];
	
	// 抓 global data 判斷自動播放的設定
	self.autoPlaySwitch.on = [iBGGlobalData sharedInstance].autoPlayIsOn;
	[self.autoPlaySwitch addTarget:self action:@selector(changeAutoPlaySwitch:) forControlEvents:UIControlEventValueChanged];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeFacPushSwitch:(UISwitch *)sender{
	if([sender isOn]){
		NSLog(@"FacPush ON");
		[iBGGlobalData sharedInstance].facilityPushIsOn = YES;
	} else{
		NSLog(@"FacPush OFF");
		[iBGGlobalData sharedInstance].facilityPushIsOn = NO;
	}
}

- (void)changeAutoPlaySwitch:(UISwitch *)sender{
	if([sender isOn]){
		NSLog(@"Autoplay ON");
		[iBGGlobalData sharedInstance].autoPlayIsOn = YES;
	} else{
		NSLog(@"Autoplay OFF");
		[iBGGlobalData sharedInstance].autoPlayIsOn = NO;
	}
}

- (IBAction)clickFBLogout:(UIButton *)sender {
	
	FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
	[loginManager logOut];
	
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
	hud.mode = MBProgressHUDModeCustomView;
	// hud.margin = 10.f;
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	hud.labelText = @"已登出";
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:2];
	
	[self.navigationController.navigationController popToRootViewControllerAnimated:YES];
	
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
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

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	
//	return 2;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
}


@end
