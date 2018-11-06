//
//  OrderRequestModel.h
//  MopinProject
//
//  Created by xhd945 on 15/12/19.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderRequestModel : NSObject

@property (nonatomic,strong)NSString *userID;  //用户ID
@property (nonatomic,strong)NSString *PenManID;  //书家ID
@property (nonatomic,strong)NSString *AddressID;//地址ID
@property (nonatomic,strong)NSString *ArtID;//样品ID
@property (nonatomic,strong)NSString *Content;//书写内容
@property (nonatomic,strong)NSString *IsTiKuan;//是否提款
@property (nonatomic,strong)NSString *TKContent;//提款内容（有提款的情况下赋值）
@property (nonatomic,strong)NSString *ZhBType;//装裱类型1：框裱  2：轴裱  3：不装裱
@property (nonatomic,strong)NSString *ZhBStyleID;//装裱样式ID注：装裱类型对应的样式ID
@property (nonatomic,strong)NSString *OrderNum;//订购数量
@property (nonatomic,strong)NSString *Remark;//买家留言
@property (nonatomic,strong)NSString *SJCouponUsed;//使用的书家券ID注：多个用英文逗号隔开
@property (nonatomic,strong)NSString *MPCouponUsed;//使用的墨品券ID注：多个用英文逗号隔开
@property (nonatomic,strong)NSString *ReceiptContent;//发票内容内容是：个人或者公司名字
@property (nonatomic,strong)NSString *Amount;  //实际支付金额（校验）


#pragma mark -- 样品信息
@property (nonatomic,strong)NSString *Price; //价格
@property (nonatomic,strong)NSString*PhotoURL;   //样品照片
@property (nonatomic,strong)NSString*wordType;  //字体
@property (nonatomic,strong)NSString*showType; //显示尺寸
@property (nonatomic,strong)NSString*size;     //大小
@property (nonatomic,strong)NSString*paperType;
@property (nonatomic,strong)NSString*zouQi;

@property (nonatomic,strong)NSString*  canUseMpJuan;//可用墨品劵
@property (nonatomic,strong)NSString*  canUseMpJuanAmount; //可用卷金额
@property (nonatomic,strong)NSString*  canUseSjJuan;//可用书家劵
@property (nonatomic,strong)NSString*  canUseSjJuanAmount;

@property (nonatomic,strong)NSString* ZhuanBiaoPrice;//装裱价格

@property (nonatomic,strong)NSString*Place;//适用场所 返回的时候多个用|线隔开
@property (nonatomic,strong)NSString*Name;//联系人名字
@property (nonatomic,strong)NSString*Mobile;//联系人电话
@property (nonatomic,strong)NSString*Address;//地址

@property (nonatomic,strong)NSString*IsPublicGoodSample;//是否是公益样品 0-否 1-是

@end
