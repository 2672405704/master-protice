//
//  RecommendContentCell.h
//  MopinProject
//
//  Created by rt008 on 15/11/29.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecommendContentModel;
@protocol RecommendContentCellDelegate <NSObject>

- (void)deleteRecommendContent:(RecommendContentModel *)model;

@end
@interface RecommendContentCell : UITableViewCell
@property (nonatomic,strong) RecommendContentModel *model;
@property (nonatomic,weak) id<RecommendContentCellDelegate>delegate;

- (void)reloadCell;
@end
