//
//  TitleHeader.h
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#ifndef SJHairDressingProject_TitleHeader_h
#define SJHairDressingProject_TitleHeader_h


/****---  App 颜色配置 -----*****/

//屏幕宽高
#define mScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight         ([UIScreen mainScreen].bounds.size.height)

//设置颜色
#define RGBA(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a] //RGB颜色


#define THEME_BG_COLOR toPCcolor(@"eeeeee")
//主题颜色_1
#define THEMECOLOR_1 toPCcolor(@"ca3b2b")
//主题颜色_2
#define THEMECOLOR_2 toPCcolor(@"e3d495")
//白色背景分割
#define DIVLINECOLOR_1    toPCcolor(@"cccccc")
//灰色背景分割
#define DIVLINECOLOR_2    toPCcolor(@"888888")

//标题文字颜色
#define TitleFontColor     toPCcolor(@"000000")
//正文文字颜色
#define MainFontColor     toPCcolor(@"444444")
//说明文字颜色
#define TipsFontColor     toPCcolor(@"888888")



#define UIFONT_bold(size)      [UIFont boldSystemFontOfSize:size]

//正楷标题字体
#define UIFONT_Tilte(x)  [UIFont fontWithName:XiaoBiaoSong size:x]


#define PlaceHeaderImage @"tx.png" //默认头像
#define PlaceHeaderFemaleImage @"header_female.png"
#define PlaceHeaderSquareImage @"bg_gray.png" //默认正方形图
#define PlaceHeaderBigSquareImage @"bg_gray.png" //默认大正方形图

#define PlaceHeaderRectangularImage @"bg_gray" //默认长方形图
#define PlaceHeaderIconImage @"tx" //默认icon
#define PlaceHeaderPhoto @"tx.png" //默认头像
#define PlaceInfoPhoto @"tx.png"    //消息

#define ServiceTel @"4000660160" //客服电话

/********通知名字******/
#define RefreshCoupon @"RefreshCoupon"   //刷新墨基金
#define RefreshMineInfo @"RefreshMineInfo" //刷新我的
#define RefreshFavorites @"RefreshFavorites" //刷新收藏
#define RefreshPenmanDetail @"RefreshPenmanDetail" //刷新书家主页
#define RefreshPenmanAllSampleList @"RefreshPenmanAllSampleList" //刷新全部样品列表

/**********分享网址********/
#define SHARE_HOSTURL @"http://m.shufa.cn"
#define SHARE_PENMAN [NSString stringWithFormat:@"%@/moping-h5/page/penmaninfo?id=", SHARE_HOSTURL]
#define SHARE_SAMPLE [NSString stringWithFormat:@"%@/moping-h5/page/sampleinfo?id=", SHARE_HOSTURL]
#define SHARE_INVITE_URL [NSString stringWithFormat:@"%@/moping-h5/app/yaoqing", SHARE_HOSTURL]
#define SHARE_IMAGE_URL [NSString stringWithFormat:@"%@/moping-h5/resources/images/lqmjj.jpg", SHARE_HOSTURL]
#define BOOK_GUIDE_URL [NSString stringWithFormat:@"%@moping-http/sjzn", RootURL]
/*******限制字数***********/
//发布样品
#define SAMPLE_RECOMMEND_LENGTH 20
#define SAMPLE_TITLE_LENGTH 30
#define SAMPLE_CONTENT_LENGTH 400

#define kkSureButtonH  45.0f

//友盟AppKey
#define UMengAPPKey @"56c3108b67e58e7669002113"

//极光推送AppKey
#define JPushKey @"9dd9708b80636379cf95a351"

#pragma mark ---- 支付宝信息 ----

//支付宝回调地址
#define AliPayNotifyURL [NSString stringWithFormat:@"%@/moping-http/notify_url", RootURL]


//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088121333046089" //正式账号

//收款支付宝账号
#define SellerID  @"2088121333046089" //正式账号


//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"c0tbvxxgbu44s24e35x4ncqoqbpurqpf" //正式账号


//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMBPUHGtUSLLzFyO2MwbYppQxyai0Afk5R57EUGT2IFxoeG7KcX/ok2mlwDg1QkrlDu6Cjafe8mVT7EqrlTJVNkgx6ADN1kbN3YSKgHaAs01sFqEdFw8XeAI6jTOZpzBHCBzqZSZC11VNJVPyLSsgek5hh6SpiJpUea0Escw7T2jAgMBAAECgYApt8sCrg+A1eciWRasyHAOe+GH/x/T5pLRlu76Y+E+y3DLsDdyrW7/G1l8pklwsNR6VHRsvxIye8KK83BYEkjmZO3o3DGa+603pxm+0AF4Q23J2A4mX4gBgmL1tedP2W1P7s3VM6fv+K4SQ96Jkx5o9aqChgSckX703g+8a+1E+QJBAOpTSyefAobDrEBMfPBw87/vCWW+tlJ4lu/Ah0Ty6ppYTa8L4/snrW1SfAvRn7p5gZ62I54YK7PBKerWPVkqQhcCQQDSGR0gHq6uYNJLkJi0xO3q1UyfAbx/639BTyE/92/NQEvqF4phQjXmXq/7XbYllgZ5x6PLNXyWImeGQk9T0JRVAkA1PvAY9LzyOoxtn/PT/xakSoDsKcXsP5KssCcMt9YvdFlSqXUIoR97c/7UALI3AV0+30yApCVqFz6bKkuOc1fJAkBw4EE/onxi/228X2FLrYnNYu+ZdgtaBqIF6oeIoF2WvnaKvD8CZdojfLe7qutTYjj0cIfVg1T+LFnGThXkh+lJAkEA4pSx5cCDV0buC95bPXiNgzclePtEU6TVNuGL4QWq2WwOsNMtRSimR4xzoOfmtZV0yS3nHI/gfIx0W2hucSZgDg=="


//支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"


#endif
