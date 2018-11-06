//
//  EvaluteSampleCell.h
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EvaluteListModel;
@class PenmanDetailCommentModel;
@protocol EvaluteSampleCellDelegate <NSObject>

@optional
- (void)stickEvaluteList:(EvaluteListModel *)model;
- (void)replyEvalute:(EvaluteListModel *)model;
@end
@interface EvaluteSampleCell : UITableViewCell

@property (nonatomic,strong) EvaluteListModel *model;
@property (nonatomic,weak) id<EvaluteSampleCellDelegate> delegate;

- (void)reloadCell;
+ (CGFloat)getHeightWithModel:(EvaluteListModel *)model;

- (void)reloadPenmanDetailCommentWithModel:(PenmanDetailCommentModel *)model; //书家详情
+ (CGFloat)getHeightWithModelInPenmanDetail:(PenmanDetailCommentModel *)model;//书家详情
@end
