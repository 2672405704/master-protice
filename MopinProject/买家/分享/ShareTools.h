//
//  ShareTools.h
//  DongBa
//
//  Created by rt008 on 15/3/2.
//  Copyright (c) 2015年 xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppKey.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

typedef NS_ENUM(NSUInteger,ShareMoPinType){
    ShareMoPinPenmanType,  //分享书家主页
    ShareMopinSampleType,  //分享样品
    ShareMopinInviteFriendType, //邀请好友
};

@interface ShareMopinModel : NSObject
@property (nonatomic,copy) NSString *title; //标题
@property (nonatomic,assign) ShareMoPinType type; //类型
@property (nonatomic,copy) NSString *shareUrl; //分享网址
@property (nonatomic,copy) NSString *imageUrl;; //图片网址
@property (nonatomic,copy) NSString *desc; //描述
@property (nonatomic,copy) NSString *sharedId; //分享的时候调用请求的参数 //类型为主页时表示分享墨品券的Id
@end

@interface ShareTools : NSObject
//sharesdk分享
+ (void)initShare;
//分享内容定制
+ (void)shareAllButtonClickHandler:(ShareMopinModel *)shareModel andSucess:(void(^)())sucess;
//第三方登陆
+ (void)loginToThirdWithType:(NSUInteger)type andSucess:(void(^)())sucess;
+ (void)logOut; //退出清除缓冲
@end
