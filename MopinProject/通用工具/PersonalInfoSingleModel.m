//
//  PersonalInfoSingleModel.m
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/11.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PersonalInfoSingleModel.h"

@implementation PersonalInfoSingleModel
//TODO:创建单例
+ (instancetype)shareInstance
{
    static PersonalInfoSingleModel *personalModel=nil;
    if(!personalModel){
        
        personalModel=[[[self class] alloc]init];
    }
    return personalModel;
}
//保存某个属性值到本地
+ (void)saveValueWithKey:(NSString *)key andValue:(NSString *)value
{
    NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
    [df setObject:value forKey:key];
    [df synchronize];
}

//TODO:判断是否登录
- (BOOL)isLogin
{
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"Login"];
}

//TODO:退出登录
- (void)logOut
{
//    self.PhoneNumber=nil;
    self.UserID=nil;
    self.Phone=nil;
    self.Photo=nil;
    self.ProvinceID=nil;
    self.DistrictID=nil;
    self.ProvinceID=nil;
    self.Birthday=nil;
    self.Sex=nil;
    self.NickName=nil;
    self.type=nil;
    self.UserType=nil;
    self.UserState=nil;
    self.Sign=nil;
    self.IsBuy=nil;
    self.IsFreeQualify = nil;
    self.IsGoodPublic = nil;
    self.openType=@"";
    
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    [ud setValue:nil forKey:@"PersonalInfo"];
    [ud setBool:NO forKey:@"Login"];
    [ud synchronize];
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
