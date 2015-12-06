//
//  iBGItemCommentViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGTextInputLayer.h"

@interface iBGCommentViewController : UIViewController

@property NSString *type;
@property NSString *objID;
@property int rate;

@property NSArray *starArr;
@property (strong, nonatomic) IBOutlet UIButton *star1;
@property (strong, nonatomic) IBOutlet UIButton *star2;
@property (strong, nonatomic) IBOutlet UIButton *star3;
@property (strong, nonatomic) IBOutlet UIButton *star4;
@property (strong, nonatomic) IBOutlet UIButton *star5;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapDismissKB;
@property (strong, nonatomic) IBOutlet UIScrollView *commentScrollView;
//@property (strong, nonatomic) IBOutlet UITextField *commentTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;

@end
