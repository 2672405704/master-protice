//
//  AlipayMethod.h
//  DongBa
//
//  Created by 黄彩霞 on 15/3/23.
//  Copyright (c) 2015年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlipayMethod : NSObject

+ (AlipayMethod *)shareAlipayMethod;

- (void)alipayWithGoodsName:(NSString *)goodName OrderID:(NSString *)orderID Amount:(NSString *)amount;
//goodName商品标题，OrderID（订单ID），Amount（支付金额）


//支付宝支付成功响应通知
/*
 
 #pragma mark - 添加监听通知
 - (void)createNotification
 {
 //添加监听通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotifi:) name:@"zhifubaoPay" object:nil];
 }
 
 - (void)recieveNotifi:(NSNotification *)nf
 {
 //支付成功
 PaySuccessVC * vc = [[PaySuccessVC alloc] init];
 vc.navigationItem.hidesBackButton = YES;
 vc.courceName = _orderModel.CourseName;
 vc.money = [NSString stringWithFormat:@"%@元(%@课时)", _orderModel.Amount, _orderModel.Hours];
 //    vc.model = _orderModel;
 [self.navigationController pushViewController:vc animated:YES];
 }
 
 */

@end
