//
//  MyOrderDetailVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/21.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"


@interface MyOrderDetailVC : BaseSuperViewController
{
    NSString *_formType; //1.来自我的定制  2.来自订单管理
}
@property (nonatomic,assign) BOOL isDismiss; //是否需要dismis 从通知点击跳转
@property(nonatomic,strong)NSString *orderCode; //订单码

- (instancetype)initWithOrderCode:(NSString*)code FormType:(NSString*)type;

@end
