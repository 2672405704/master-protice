//
//  MyOrderModel.h
//  MopinProject
//
//  Created by happyzt on 15/12/19.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "WXBaseModel.h"

@interface MyOrderModel : WXBaseModel

@property (nonatomic,copy)NSString *OrderCode;   //订单Code

//订单状态  1待支付2已支付3创作中4装裱中5已装裱6已发货7待评价8已完成9售后中10取消订单
@property (nonatomic,copy)NSString *OrderState;

//样品名称
@property (nonatomic,copy)NSString *ArtName;

//书家姓名
@property (nonatomic,copy)NSString *PenmanName;


//幅式（文字）
@property (nonatomic,copy)NSString *ShowType;

//字体（文字）
@property (nonatomic,copy)NSString *WordType;

//尺寸（显示格式：70*130CM）
@property (nonatomic,copy)NSString *Size;


//促销说明
@property (nonatomic,copy)NSString *Promotional;

//样品图片
@property (nonatomic,copy)NSString *ArtPic;

//订单总金额
@property (nonatomic,copy)NSString *Price;


@property(nonatomic,strong)NSString *SJCoupon;     //下单后奖励书家券的金额
@property(nonatomic,strong)NSString *InviteFriend; //邀请好友给好友的墨品券金额
@property(nonatomic,strong)NSString *IFReturn;	   //邀请好友自己获得墨品券金额
@property(nonatomic,strong)NSString *OrderShare;   //下单后分享朋友圈的金额（大家一起领）


@end
