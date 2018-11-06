//
//  AllSampleCommentCell.h
//  MopinProject
//
//  Created by rt008 on 16/1/9.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentListMod;
@interface AllSampleCommentCell : UITableViewCell
- (void)reloadCellWithModel:(CommentListMod *)model;
+ (CGFloat)getHeightWithModel:(CommentListMod *)model;
@property (nonatomic,weak) UIViewController *delegate;
@end
