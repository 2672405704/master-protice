//
//  PersonalInfoSingleModel.h
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/11.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfoSingleModel : NSObject

@property (nonatomic,strong) NSString *UserID;    //ID
@property (nonatomic,strong) NSString *Photo;     //头像
@property (nonatomic,strong) NSString *NickName;  //昵称
@property (nonatomic,strong) NSString *Sex;//性别：0未知 1男 2女
@property (nonatomic,strong) NSString *Birthday;  //生日
@property (nonatomic,strong) NSString *Phone;     //电话
@property (nonatomic,strong) NSString *ProvinceID;//省ID
@property (nonatomic,strong) NSString *DistrictID;//区ID
@property (nonatomic,strong) NSString *CityID; //当前城市ID
@property (nonatomic,strong) NSString *type; //1表示买家 2表示卖家
@property (nonatomic,strong) NSString *UserType; //用户类型1墨客2书家3名家4大家
@property (nonatomic,strong) NSString *UserState; //用户状态0停用 ：直接返回登录失败 1正常2认证3签约：登录成功
@property (nonatomic,strong) NSString *Sign;//申请签约状态：控制签约协议展示0未申请 1申请2通过 3拒绝
@property (nonatomic,strong) NSString *IsBuy;//是否购买过产品：0：未购买过  1：购买过
@property (nonatomic,strong) NSString *ApplyState;//用户类型申请状态：-1未申请 0审核中 1通过2 不通过 UserType=1时，为申请书家的状态 UserType=2时，为申请名家的状态  大家不再App端申请不用考虑
@property (nonatomic,strong) NSString *openType; //第三方登录类型 1.QQ 2.新浪 3.微信
//创建单例
@property (nonatomic,strong) NSString *StockNum;//可接受定制数

@property (nonatomic,strong) NSString *IsFreeQualify;//是否有免费的资格:0-没有  1-有
@property (nonatomic,strong) NSString *IsGoodPublic;//是否是公益的书家 0-不是 1-是

+ (instancetype)shareInstance;
//保存某个属性值到本地
+ (void)saveValueWithKey:(NSString *)key andValue:(NSString *)value;
//是否登录过
- (BOOL)isLogin;
//退出登录
- (void)logOut;
@end
