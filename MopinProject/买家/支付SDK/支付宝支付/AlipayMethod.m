//
//  AlipayMethod.m
//  DongBa
//
//  Created by 黄彩霞 on 15/3/23.
//  Copyright (c) 2015年 xiaoxin. All rights reserved.
//

#import "AlipayMethod.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "Order.h"
#import "DataSigner.h"

@implementation AlipayMethod
{
    NSNotification * notification;
}

+ (AlipayMethod *)shareAlipayMethod
{
    AlipayMethod * method;
    if (method == nil) {
        method = [[AlipayMethod alloc] init];
    }
    
    return method;
}

- (void)alipayWithGoodsName:(NSString *)goodName OrderID:(NSString *)orderID Amount:(NSString *)amount
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    /*==============需要填写商户app申请的==========*/
    NSString *partner = PartnerID;
    NSString *seller = SellerID;
    NSString *privateKey = PartnerPrivKey;
    
    /*==========================================*/
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderID; //订单ID（由商家自行制定）
    order.productName = goodName; //商品标题
    //商品描述
    order.productDescription = [NSString stringWithFormat:@"%@%@", goodName, goodName]; //商品描述
  
    /*==========商品价格修改==========*/
#if 1
   order.amount = [NSString stringWithFormat:@"%.2f", amount.floatValue]; //商品价格
#else
    order.amount = @"0.01"; //测试商品价格
#endif
    
    order.notifyURL = AliPayNotifyURL; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme = @"AlipayMoPin";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            //【callback 处理支付结果】
            NSLog(@"reslut = %@",resultDic);
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            
            if (resultStatus == 9000)  //支付成功
            {
                //通知传值
                NSDictionary * dict = @{@"result":@"YES"};
                if (notification == nil)
                {
                    notification = [NSNotification notificationWithName:@"zhifubaoPay" object:nil userInfo:dict];
                }
                //用通知中心发送
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            else
            {
                //通知传值
                NSDictionary * dict = @{@"result":@"NO"};
                if (notification == nil) {
                    notification = [NSNotification notificationWithName:@"zhifubaoPay" object:nil userInfo:dict];
                }
                //用通知中心发送
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
            
            
        }];
        
    }
}

@end
