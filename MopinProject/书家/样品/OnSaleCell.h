//
//  OnSaleCell.h
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SampleModel;
@protocol OnSaleCellDelegate <NSObject>

- (void)deleteSample:(SampleModel *)model;
- (void)soldOutSample:(SampleModel *)model;
- (void)editSample:(SampleModel *)model;
- (void)stickSample:(SampleModel *)model;
- (void)upStoreSample:(SampleModel *)model;

@end

@interface OnSaleCell : UITableViewCell
@property (nonatomic,strong) id<OnSaleCellDelegate> delegate;
@property (nonatomic,strong) SampleModel *sampleModel;
- (void)reloadCellWithType:(NSInteger)type;
@end
