//
//  ShareTools.m
//  DongBa
//
//  Created by rt008 on 15/3/2.
//  Copyright (c) 2015年 xiaoxin. All rights reserved.
//

#import "ShareTools.h"
#import <ShareSDKUI/ShareSDKUI.h>
#define APPDownloadAdress @"www.baidu.com"

@implementation ShareMopinModel

@end


@implementation ShareTools
//TODO:初始化
+ (void)initShare
{
    
    [ShareSDK registerApp:kkShareAppKey activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeWechat)] onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            case SSDKPlatformTypeQQ:
                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeWechat:
                    [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo:
                    [appInfo SSDKSetupSinaWeiboByAppKey:kkSinaAppKey appSecret:kkSinaAppSecret redirectUri:kkSinaRedirectUrl authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeQQ:
                    [appInfo SSDKSetupQQByAppId:kkQQAppID appKey:kkQQAppKey authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeWechat:
                    [appInfo SSDKSetupWeChatByAppId:kkWeXinAppKey appSecret:kkWeXinAppSecret];
                break;
            default:
                break;
        }
    }];
    
//    [ShareSDK registerApp:kkShareAppKey];//此处应该换成自己的shareSDK_Key
// #if 1
//    /**
//     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
//     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
//     **/
//    [ShareSDK connectSinaWeiboWithAppKey:kkSinaAppKey
//                               appSecret:kkSinaAppSecret
//                             redirectUri:@"http://www.sharesdk.cn"];
//    
//    
//    /**
//     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
//     http://con nect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
//     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
//     **/
//    [ShareSDK connectQZoneWithAppKey:kkQQAppID
//                           appSecret:kkQQAppKey
//                    qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
//    
//    /**
//     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
//     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
//     **/
//    [ShareSDK connectWeChatWithAppId:kkWeXinAppKey
//                           appSecret:kkWeXinAppSecret
//                           wechatCls:[WXApi class]];
//    
//    /**
//     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
//     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
//     **/
//    [ShareSDK connectQQWithQZoneAppKey:kkQQAppID
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
//    
//    //短信
//    [ShareSDK connectSMS];
//    
//#endif
    
}
/**
  *
  *
  **/
//+ (void)shareAllButtonClickHandler:(NSString *)activityName andType:(ShareMoPinType)type andUrl:(NSString *)activityUrl andDes:(NSString *)activityImageUrl andTitle:(NSString *)title
+ (void)shareAllButtonClickHandler:(ShareMopinModel *)shareModel andSucess:(void(^)())sucess
{
    NSMutableDictionary *shareParams=[NSMutableDictionary dictionary];
    
    //分享图片设置
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://101.200.74.205:8081/moping-h5/resources/images/lqmjj.jpg"]]];
    
    [shareParams SSDKSetupShareParamsByText:shareModel.desc images:image url:shareModel.shareUrl.length?[NSURL URLWithString:shareModel.shareUrl]:[NSURL URLWithString:APPDownloadAdress] title:shareModel.title type:SSDKContentTypeAuto];
   
//    [shareParams SSDKSetupSinaWeiboShareParamsByText:@"定制新浪微博的分享内容" title:nil image:image url:activityUrl.length?[NSURL URLWithString:activityUrl]:[NSURL URLWithString:APPDownloadAdress] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
//    [shareParams SSDKSetupQQParamsByText:@"定制QQ分享内容" title:nil url:activityUrl.length?[NSURL URLWithString:activityUrl]:[NSURL URLWithString:APPDownloadAdress] thumbImage:nil image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
//    [shareParams SSDKSetupQQParamsByText:@"定制QQ分享内容" title:nil url:activityUrl.length?[NSURL URLWithString:activityUrl]:[NSURL URLWithString:APPDownloadAdress] thumbImage:nil image:image type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
//    [shareParams SSDKSetupWeChatParamsByText:@"定制微信分享内容" title:@"微信分享" url:activityUrl.length?[NSURL URLWithString:activityUrl]:[NSURL URLWithString:APPDownloadAdress] thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
//    [shareParams SSDKSetupWeChatParamsByText:@"定制微信分享内容" title:@"朋友圈分享" url:activityUrl.length?[NSURL URLWithString:activityUrl]:[NSURL URLWithString:APPDownloadAdress] thumbImage:nil image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [ShareSDK showShareActionSheet:nil items:@[@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformSubTypeWechatSession)] shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
                //已知BUG 分享成功直接点留着界面 再重主界面打开App不会走分享成功 会走取消分享
                if(shareModel.type==ShareMoPinPenmanType){
                    
                    [self getCouponShared:shareModel.sharedId andSucess:sucess];
                }
                break;
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
//                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SSDKResponseStateCancel:
            {
                
                break;
            }
            default:
                break;
        }
    }];
//
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:activityName
//                                       defaultContent:@"彩票联盟"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"快来加入彩票联盟吧~"
//                                                  url:activityUrl.length?activityUrl:APPDownloadAdress// 跳转的网页
//                                          description:nil
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //TODO:定制微博分享消息
//    [publishContent addSinaWeiboUnitWithContent:activityName.length?activityName:@"彩票联盟" image:nil];
//   
//    //TODO:定制微信朋友圈信息
//    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
//                                          content:activityName.length?activityName:@"彩票联盟"
//                                            title:activityUser
//                                              url:activityUrl.length?activityUrl:APPDownloadAdress
//                                       thumbImage:[ShareSDK imageWithPath:imagePath]
//                                            image:[ShareSDK imageWithPath:imagePath]
//                                     musicFileUrl:nil
//                                          extInfo:nil
//                                         fileData:nil
//                                     emoticonData:nil];
//    
//    //定制微信好友信息
//    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
//                                         content:activityUser
//                                           title:activityName.length?activityName:@"彩票联盟"
//                                             url:activityUrl.length?activityUrl:APPDownloadAdress
//                                      thumbImage:[ShareSDK imageWithPath:imagePath]
//                                           image:[ShareSDK imageWithPath:imagePath]
//                                    musicFileUrl:nil
//                                         extInfo:nil
//                                        fileData:nil
//                                    emoticonData:nil];
//    //定制QQ分享信息
//    [publishContent addQQUnitWithType:INHERIT_VALUE
//                              content:activityUser
//                                title:activityName
//                                  url:activityUrl
//                                image:[ShareSDK imageWithPath:imagePath]];
//    //定制QQ空间分享
//    [publishContent addQQSpaceUnitWithTitle:activityName url:activityUrl site:@"site" fromUrl:@"fromUrl" comment:@"asdj" summary:@"adskl" image:nil type:@(1) playUrl:nil nswb:nil];
//    
//    [publishContent addSMSUnitWithContent:[NSString stringWithFormat:@"快来加入彩票联盟吧,下载地址:%@",APPDownloadAdress]];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:nil
//                         shareList:[NSMutableArray arrayWithObjects:
//                                    [NSNumber numberWithInt:SSCShareTypeWeixiSession],
//                                    [NSNumber numberWithInt:SSCShareTypeWeixiTimeline],
//                                    [NSNumber numberWithInt:SSCShareTypeSinaWeibo],
//                                    [NSNumber numberWithInt:SSCShareTypeQQ],
//                                    [NSNumber numberWithInt:SSCShareTypeQQSpace],
//                                    [NSNumber numberWithInt:SSCShareTypeSMS],
//                                    nil]
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    
//                                   NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
    
}
+ (void)getCouponShared:(NSString *)sharedId andSucess:(void(^)())sucess
{
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCouponShared" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:sharedId forKey:@"SharedID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if(code.integerValue==1000){
            if(sharedId.intValue!=0){
                sucess();
            }
        }

    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:第三方登陆
+ (void)loginToThirdWithType:(NSUInteger)type andSucess:(void(^)())sucess
{
    [ShareSDK getUserInfo:type onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if(state==SSDKResponseStateSuccess){
            
            NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
            [parameterDic setValue:@"AuthorizeLogin" forKey:@"Method"];
            [parameterDic setValue:Infversion forKey:@"Infversion"];
            if(type==SSDKPlatformSubTypeQZone){
                [parameterDic setValue:user.uid forKey:@"OpenID"];
                [parameterDic setValue:user.nickname forKey:@"NickName"];
                [parameterDic setValue:user.icon forKey:@"Photo"];
                [parameterDic setValue:@"1" forKey:@"Type"];
                [parameterDic setValue:@"" forKey:@"UnionID"];
            }else if(type==SSDKPlatformTypeSinaWeibo){
                [parameterDic setValue:user.uid forKey:@"OpenID"];
                [parameterDic setValue:user.nickname forKey:@"NickName"];
                [parameterDic setValue:user.icon forKey:@"Photo"];
                [parameterDic setValue:@"3" forKey:@"Type"];
                [parameterDic setValue:@"" forKey:@"UnionID"];

            }else{
                [parameterDic setValue:user.uid forKey:@"OpenID"];
                [parameterDic setValue:user.nickname forKey:@"NickName"];
                [parameterDic setValue:user.icon forKey:@"Photo"];
                [parameterDic setValue:@"2" forKey:@"Type"];
                [parameterDic setValue:user.rawData[@"openid"] forKey:@"UnionID"];
            }
            
            [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
                NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
                
                NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
                NSString * msg = jsonObject[@"msg"];
                [DictionaryTool showResult:msg withCode:code.integerValue];
                
                if (code.integerValue == 1000) {
                    //保存ID
                    NSDictionary *dic=jsonObject[@"data"][0];
                    NSMutableDictionary *mutabDic=[NSMutableDictionary dictionaryWithDictionary:dic];
                    [mutabDic setValue:@"1" forKey:@"type"];
                    
                    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
                    [personalModel setValuesForKeysWithDictionary:mutabDic];
                    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
                    
                    [ud setValue:mutabDic forKey:@"PersonalInfo"];
                    [ud setBool:YES forKey:@"Login"];
                    [ud synchronize];
                    
                    
                    sucess();
                    //            MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
                    //            [self presentViewController:mtbc animated:YES completion:^{
                    //                WINDOW.rootViewController=mtbc;
                    //            }];
                }
            } failure:^(NSError *error){
                
                [SVProgressHUD dismiss];
                NSLog(@"%@",error);
                
            }];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}
//TODO:退出
+ (void)logOut
{
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    if(personalModel.openType.length==0){
        [personalModel logOut];
        return;
    }else if(personalModel.openType.intValue==1){
        [ShareSDK cancelAuthorize:SSDKPlatformSubTypeQZone];
    }else if(personalModel.openType.intValue==2){
        [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
    }else{
        [ShareSDK cancelAuthorize:SSDKPlatformSubTypeWechatSession];
    }
    [personalModel logOut];
}
@end
