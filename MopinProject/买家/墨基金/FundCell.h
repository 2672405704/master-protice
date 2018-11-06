//
//  FundCell.h
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FundModel;
@class CouponMainModel;
@class MyCouponModel;
@class CouponMopinModel;

@protocol FundCellDelegate <NSObject>
- (void)getCouponWithModel:(CouponMopinModel *)model; //书家详情领取书家券
@end

@interface FundCell : UITableViewCell
@property (nonatomic,weak) id<FundCellDelegate>delegate;
- (void)reloadCellWithModel:(FundModel *)model;
- (void)reloadCellWithCouponModel:(CouponMainModel *)model;
- (void)reloadcellWithMyCouponModel:(MyCouponModel *)model;
- (void)reloadCellWithMopinModel:(CouponMopinModel *)model;
- (void)reloadCellInPenmanDetailWithModel:(CouponMopinModel *)model;  //书家详情
@end
