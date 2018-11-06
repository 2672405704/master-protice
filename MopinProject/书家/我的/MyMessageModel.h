//
//  MyMessageModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/16.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface MyMessageModel : SuperModel
@property (nonatomic,copy,readonly) NSString *Id;        //类型（详情见“消息推送规则.xlsx”）
@property (nonatomic,copy,readonly) NSString *Title;     //记录id
@property (nonatomic,copy,readonly) NSString *Content;   //标题
@property (nonatomic,copy,readonly) NSString *CreateTime;//时间
@property (nonatomic,copy,readonly) NSString *Photo;     //头像
@property (nonatomic,copy,readonly) NSString *Flag;      //跳转标记:有跳转的时候再用
@property (nonatomic,copy,readonly) NSString *IsRead;    //阅读标记（0红点，1消除）
@property (nonatomic,copy,readonly) NSString *Type;      //1.用户领取书家广场券 2.用户关注书家 3.用户分享了书家信息 4.用户申请了书家，后台审核通过  //书家端：5.用户收藏了书家的样品 6.用户买了书家的作品、提交订单并支付 7.书家申请了名家 8.后台标记了大家身份
@end
