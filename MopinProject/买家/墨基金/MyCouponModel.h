//
//  MyCouponModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/16.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface MyCouponModel : SuperModel
@property (nonatomic,copy) NSString *CouponID;//Id
@property (nonatomic,copy) NSString *Type; //1注册2分享3首单(1.墨品劵，2，书家劵)
@property (nonatomic,copy) NSString *EndTime;//结束时间
@property (nonatomic,copy) NSString *Amount; //钱
@property (nonatomic,copy) NSString *Source; //来源

@property (nonatomic,assign)BOOL isChoose;//是否选中

@end
