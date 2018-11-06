//
//  PenmanListCell.h
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PenmanListModel;

@protocol PenmanListCellDelegate <NSObject>

- (void)cancelAttentionWithModel:(PenmanListModel *)model;

@end

@interface PenmanListCell : UITableViewCell
@property (nonatomic,weak) id<PenmanListCellDelegate>delegate;

@property (nonatomic,strong) PenmanListModel *model;

- (void)reloadCell;  //书家列表
- (void)reloadCellInMineAttention; //我的关注

@end
