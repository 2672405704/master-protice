//
//  MyOrderDetailModel.h
//  MopinProject
//
//  Created by xhd945 on 15/12/25.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface MyOrderDetailModel : SuperModel
/*订单类型
 1待支付2已支付3创作中4装裱中5已装裱6已发货7待评价8已完成9售后中10取消订单
 */
@property(nonatomic,strong)NSString *State;//

@property(nonatomic,strong)NSString *Name;//
@property(nonatomic,strong)NSString *Address;//
@property(nonatomic,strong)NSString *Mobile;//手机号

@property(nonatomic,strong)NSString *WordNum;//
@property(nonatomic,strong)NSString *Size;//
@property(nonatomic,strong)NSString *ShowType;//
@property(nonatomic,strong)NSString *Wordtype;//
@property(nonatomic,strong)NSString *ISInscribe;//是都支持题款
@property(nonatomic,strong)NSString *Material;//纸张
@property(nonatomic,strong)NSString *CreateCycle;//创作周期

@property(nonatomic,strong)NSString *OrderNum;//订购数量
@property(nonatomic,strong)NSString *Remark;//留言
@property(nonatomic,strong)NSString *Deliver;//运费
@property(nonatomic,strong)NSString *Price;//样品价格
@property(nonatomic,strong)NSString *SJCoupon;//使用的书家券金额
@property(nonatomic,strong)NSString *MPCoupon;//使用的墨品券金额
@property(nonatomic,strong)NSString *Discount;//折扣价
@property(nonatomic,strong)NSString *Packprice;//装裱费
@property(nonatomic,strong)NSString *Amount;//金额
@property(nonatomic,strong)NSString *Receiptcontent;//发票抬头
@property(nonatomic,strong)NSString * PicPath; //图片地址
@property(nonatomic,strong)NSString *ZhBStyle; //装裱样式

#warning 貌似缺了个东西 图片
@end
