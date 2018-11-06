//
//  orderModel.h
//  MopinProject
//
//  Created by happyzt on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXBaseModel.h"

@interface orderModel : WXBaseModel

@property(nonatomic,copy)NSString *OrderState;   //订单状态  2已支付（待创作）3创作中4装裱中5已                 装裱6已发货7待评价8已完成9售后中10取消订单
@property(nonatomic,copy)NSString *OrderCode;   //订单code
@property(nonatomic,copy)NSString *ArtName;       //样品名称
@property(nonatomic,copy)NSString *PenmanName;    //书家姓名
@property(nonatomic,copy)NSString *Promotional;   //促销说明
@property(nonatomic,copy)NSString *ShowType;      //幅式（文字）
@property(nonatomic,copy)NSString *WordType;      //字体（文字）
@property(nonatomic,copy)NSString *Size;         // 尺寸
@property(nonatomic,copy)NSString *ArtPic;       //样品图片
@property(nonatomic,copy)NSString *Price;       //订单总金额
@property(nonatomic,copy)NSString *OrderCreate; //创建时间

@end
