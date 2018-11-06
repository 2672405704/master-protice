//
//  CouponMainModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/4.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface CouponMainModel : SuperModel
@property (nonatomic,copy) NSString *CouponID;
@property (nonatomic,copy) NSString *Type; //1注册2分享3首单
@property (nonatomic,copy) NSString *SendReason;
@property (nonatomic,copy) NSString *Amount;
@end
