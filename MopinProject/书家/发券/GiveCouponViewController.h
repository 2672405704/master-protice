//
//  GiveCouponViewController.h
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@class NormalCouponModel;

typedef enum : NSUInteger {
    CommonCouponTypeAttend =1,
    CommonCouponTypeShare  =2,
    CommonCouponTypeFirstBuy  =3,
} CommonCouponType;

@interface GiveCouponViewController : BaseSuperViewController
@property (nonatomic,assign) CommonCouponType type; //1.关注 2.分享 3.首次成功定制
@property (nonatomic,strong) void (^resetNormalCoupon)();
@property (nonatomic,strong) NormalCouponModel *model;
@end
