//
//  PenmanDetailModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/9.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface PenmanDetailModel : SuperModel
@property (nonatomic,copy,readonly) NSString *TrueName; //真实姓名
@property (nonatomic,copy,readonly) NSString *PenName; //笔名
@property (nonatomic,copy,readonly) NSString *UserType; //书家类型2书家3名家4大家
@property (nonatomic,copy,readonly) NSString *BackPic; //背景图片地址
@property (nonatomic,copy,readonly) NSString *IsBooked; //是否签约0:未签约  1：未签约
@property (nonatomic,copy,readonly) NSString *Trend;//-1:下降  0：不变  1：上升
@property (nonatomic,copy,readonly) NSString *Intro; //书法家简介
@property (nonatomic,copy,readonly) NSString *NPrice; //润格价格
@property (nonatomic,copy,readonly) NSString *AveragePrice; //均价
@property (nonatomic,copy,readonly) NSString *EvaluationNum; //评价数量
@property (nonatomic,copy) NSArray *EvaluationArr; //评价数组
@property (nonatomic,copy,readonly) NSString *SampleNum; //样品数量
@property (nonatomic,copy) NSArray *SampleArr; //样品数组
@property (nonatomic,copy) NSArray *CouponArr; //书家券数组
@property (nonatomic,copy) NSString *AttendNum; //关注数量
@property (nonatomic,copy) NSString *IsAttend;//1：未关注 2：已关注
@property (nonatomic,copy,readonly) NSString *StockNum; //可定制数量 如果可定制数量为0，显示：该书家暂不接收定制
@property (nonatomic,copy,readonly) NSString *IsPublicGoodPM;//是否是公益书家0：不是公益书家（不显示图标）1：公益书家（红色图标）2：是公益书家但是没有库存（灰色图片）
@property (nonatomic,copy,readonly) NSString *noncommercialstock; //公益库存
@end
