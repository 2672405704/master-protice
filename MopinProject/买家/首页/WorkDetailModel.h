//
//  WorkDetailModel.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//
        /*样品详情model*/

#import <Foundation/Foundation.h>

@interface WorkDetailModel : NSObject

@property(nonatomic,strong)NSArray *Image;//样品图片
@property(nonatomic,strong)NSString *Price; //价格
@property(nonatomic,strong)NSString*Size;//篇幅
@property(nonatomic,strong)NSString*CouponsRatio ; //样品所有券的比例
@property(nonatomic,strong)NSString*MPCouponRatio ;//墨品券比例
@property(nonatomic,strong)NSString*MPCouponAmount;//墨品券对应的金额
@property(nonatomic,strong)NSString*SJCouponRatio; //书家券的比例
@property(nonatomic,strong)NSString*SJCouponAmount;//书家券对应的金额
@property(nonatomic,strong)NSString*Intro;//样品介绍
@property(nonatomic,strong)NSString*ZanNum;//赞的数量
@property(nonatomic,strong)NSString*CollectNum;//收藏次数
@property(nonatomic,strong)NSString*BookedNum;//定制数量
@property(nonatomic,strong)NSString*IsZan; //当前用户是否赞过1：没赞  2：赞了
@property(nonatomic,strong)NSString*IsCollect;//当前用户是否收藏过1：没收藏  2：收藏了

#pragma mark -- 第二段
@property(nonatomic,strong)NSString*EvaluationNum;//评价数量
@property(nonatomic,strong)NSArray *Evaluation;//评价的数组

#pragma mark -- 第三段

@property(nonatomic,strong)NSString*ReturnCoupon;//返券金额
@property(nonatomic,strong)NSString*Promotional;//促销说明

#pragma mark -- 第四段
@property(nonatomic,strong)NSString*Place; //适用场所 返回的时候多个用|线隔开

#pragma mark -- 第5段
@property(nonatomic,strong)NSString*ArtName;//样品名字
@property(nonatomic,strong)NSString*ShowType;//类型
@property(nonatomic,strong)NSString*WordType;//字体
@property(nonatomic,strong)NSString*WordNum;//样品字数（显示格式：2-4字）
@property(nonatomic,strong)NSString*ISInscribe;//是否支持落款 0：不支持  1：支持
@property(nonatomic,strong)NSString*Material;//样品材料（显示文字）
@property(nonatomic,strong)NSString*CreateCycle;//创作周期（文字）

@property(nonatomic,strong)NSString*WNMax; //最大字数
@property(nonatomic,strong)NSString*WNMix; //最小字数

#pragma mark -- 第6段
@property(nonatomic,strong)NSString*PenmanName;//书家名称
@property(nonatomic,strong)NSString*PenmanType;//书家类别
@property(nonatomic,strong)NSString*IsBooked;//是否签约 0：未签约 1：签约
@property(nonatomic,strong)NSString*Signature;//书家签名（书家简介）
@property(nonatomic,strong)NSString*PMID; // 书家ID
@property(nonatomic,strong)NSString*Photo;//头像地址
@property(nonatomic,strong)NSString*Trend;//势：-1:下降  0：不变  1：上升
@property(nonatomic,strong)NSString*NPrice;//润格价格
@property(nonatomic,strong)NSString*AveragePrice;//AveragePrice

/*
是否是公益书家
0：不是公益书家（不显示图标）
1：公益书家（红色图标）
2：是公益书家但是没有库存（灰色图片）
 */
@property(nonatomic,strong)NSString *IsPublicGoodPM;
//是否是公益样品
@property(nonatomic,strong)NSString *IsPublicGoodSample;

@end
