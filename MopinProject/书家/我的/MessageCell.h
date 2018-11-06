//
//  MessageCell.h
//  MopinProject
//
//  Created by rt008 on 15/12/14.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyMessageModel;
@interface MessageCell : UITableViewCell
- (void)reloadCellWithModel:(MyMessageModel *)model;
+ (CGFloat)getHeightWithModel:(MyMessageModel *)model;
@end
