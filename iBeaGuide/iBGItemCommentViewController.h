//
//  iBGItemCommentViewController.h
//  iBeaGuide
//
//  Created by din1030 on 2015/11/3.
//  Copyright © 2015年 Cheng Chia Ting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iBGTextInputLayer.h"

@interface iBGItemCommentViewController : UIViewController

@property NSString *type;
@property NSInteger *objID;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapDismissKB;
@property (strong, nonatomic) IBOutlet UIScrollView *commentScrollView;
//@property (strong, nonatomic) IBOutlet UITextField *commentTitleTextField;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;

@end
