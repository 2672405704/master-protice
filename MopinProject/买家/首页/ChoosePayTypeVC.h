//
//  ChoosePayTypeVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface ChoosePayTypeVC : BaseSuperViewController

@property(nonatomic,strong)NSString *orderCode; //订单编号
@property(nonatomic,strong)NSString *Amount;  //订单金额


@property(nonatomic,strong)NSString *SJCoupon;     //下单后奖励书家券的金额
@property(nonatomic,strong)NSString *InviteFriend; //邀请好友给好友的墨品券金额
@property(nonatomic,strong)NSString *IFReturn;	   //邀请好友自己获得墨品券金额
@property(nonatomic,strong)NSString *OrderShare;   //下单后分享朋友圈的金额（大家一起领）

@end
