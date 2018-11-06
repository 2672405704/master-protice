//
//  HomePageModel.h
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SuperModel.h"

@interface HomePageModel : SuperModel
@property (nonatomic,copy,readonly) NSString *HomePageID; //首页ID
@property (nonatomic,copy,readonly) NSString *Type;       //类型1样品列表2书家列表3商品详情4书家详情5基金详情
@property (nonatomic,copy,readonly) NSString *Type2;      //调整类型：1：App 2：Web
@property (nonatomic,copy,readonly) NSString *DisplayOrder;//显示顺序
@property (nonatomic,copy,readonly) NSString *PicPath;     //图像地址
@property (nonatomic,copy,readonly) NSString *JumpPath;     //跳转地址
@property (nonatomic,copy,readonly) NSString *ItemID;//书家or样品ID
@property (nonatomic,copy,readonly) NSString *JumpTitle;//跳转标题
@end
