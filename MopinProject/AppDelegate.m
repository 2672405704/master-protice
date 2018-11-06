//
//  AppDelegate.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "AppDelegate.h"
#import "ShareTools.h"
#import "GuideViewController.h"
#import  "PublicWelfareManager.h"

//支付宝相关头文件
#import <AlipaySDK/AlipaySDK.h>
#import "AlixPayResult.h"
#import "DataVerifier.h"
//微信相关头文件
#import "WXApi.h"
#import "payRequsestHandler.h"//APP端签名相关头文件

//友盟
#import <MobClick.h>

//极光推送
#import "JPUSHService.h"

#import "MyOrderDetailVC.h"
@interface AppDelegate ()<WXApiDelegate,UIAlertViewDelegate>
{
    NSNotification * notification; //支付宝支付结果发出通知
    NSString *_orderID; //订单id
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    /*得到公益开关*/
    [[PublicWelfareManager shareInstance]requestPublicWelfareState];
    
    /*分享*/
    [ShareTools initShare];
    
    /*向微信注册*/
    [WXApi registerApp:WeiXin_APP_ID withDescription:@"MoPin"];
    
    /*读取用户信息*/
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    [personalModel setValuesForKeysWithDictionary:[mUserDefaults valueForKey:@"PersonalInfo"]];
    
    /*友盟*/
    [MobClick startWithAppkey:UMengAPPKey reportPolicy:REALTIME channelId:nil];
    
    /*是否第一次登陆*/
    if(![mUserDefaults boolForKey:@"isFirstStart"]){
        GuideViewController *gvc=[[GuideViewController alloc]init];
        self.window.rootViewController=gvc;
    }else{
        if(personalModel.isLogin)
        {
            MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:personalModel.type.intValue andSelectedIndex:0];
            self.window.rootViewController=mtbc;
        }else{
            MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
            self.window.rootViewController=mtbc;
        }
    }
    
    /******************************极光推送*****************************/
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }else{
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey channel:@"Publish channel" apsForProduction:YES];
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    
    return YES;
}
#pragma mark -- 

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    [self receiveRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //iOS 7 support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self receiveRemoteNotification:userInfo];
}
//TODO:处理推送
- (void)receiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *dic=userInfo[@"extra"];
    if([dic[@"type"] intValue]!=6){
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:userInfo[@"title"] message:userInfo[@"msg_content"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            _orderID=userInfo[@"dealid"];
            [al show];
        }
    }else{
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:userInfo[@"title"] message:userInfo[@"msg_content"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [al show];
        }else{
            [self jumpToOrder:userInfo[@"dealid"]];
        }
    }
}
//TODO:alerView 提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        return;
    }
    [self jumpToOrder:_orderID];
}
//TODO:跳到订单
- (void)jumpToOrder:(NSString *)orderID
{
#warning 我不知道是否接受到通知后书家或是买家都的条到订单详情，买家1，卖家2
    MyOrderDetailVC *orderDetailVC = [[MyOrderDetailVC alloc] initWithOrderCode:orderID FormType:@"1"];
    
    orderDetailVC.isDismiss=YES;
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:orderDetailVC];
    [self.mtbc presentViewController:nc animated:YES completion:nil];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@",error);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/***************************************************/
//此方法只适用于iOS9以后以及Xcode7以后
#if __IPHONE_9_0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    /*白名单策略影响的仅仅是 canOpenURL: 接口，OpenURL: 不受影响，这些大厂只调用 openURL: 所以不受 iOS9 的影响。*/
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        
        NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
        if (resultStatus == 9000) { //支付成功
            
            //通知传值
            NSDictionary * dict = @{@"result":@"YES"};
            if (notification == nil) {
                notification = [NSNotification notificationWithName:@"zhifubaoPay" object:nil userInfo:dict];
            }
            //用通知中心发送
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } else {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"支付失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
        
    }];
    
    return [WXApi handleOpenURL:url delegate:self];
    
}
#endif

//TODO:支付宝、微信回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方￼法里面处理跟 callback 一样的逻辑】
                                                      
                                                      [self parseURL:url application:application];
                                                  }];
        return YES;
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        
        //TODO:跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
           
            [self parseURL:url application:application];
        }];
        return YES;
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

//支付宝结果验证
- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
    NSLog(@"%@",result.statusMessage);
    NSLog(@"%@",result.resultString);
    NSLog(@"%@",result.signString);
    NSLog(@"%@",result.signType);
    NSLog(@"%d",result.statusCode);
    if (result) {
        NSLog(@"%@......",result.statusMessage);
        //是否支付成功
        if (9000 == result.statusCode) {
            /*
             *用公钥验证签名
             */
            id<DataVerifier> verifier = CreateRSADataVerifier(AlipayPubKey);
            if ([verifier verifyString:result.resultString withSign:result.signString]) {
                
                NSArray *arr = [result.resultString componentsSeparatedByString:@"&"];
                NSString *orderID = @"";
                for (int i=0; i<arr.count; i++) {
                    NSString *aaa = [arr objectAtIndex:i];
                    if ([aaa hasPrefix:@"out_trade_no="]) {
                        orderID = [aaa stringByReplacingOccurrencesOfString:@"out_trade_no=\"" withString:@""];
                        NSLog(@"%@",orderID);
                        orderID = [orderID stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                        NSLog(@"%@",orderID);
                    }
                }
                
                NSLog(@"---------支付成功----------");
                
                //                mAlertView(@"提示", @"支付成功");
                
                //通知传值
                NSDictionary * dict = @{@"result":@"YES"};
                if (notification == nil) {
                    notification = [NSNotification notificationWithName:@"zhifubaoPay" object:nil userInfo:dict];
                }
                //用通知中心发送
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            }//验签错误
            else {
                
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"签名错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
        }
        //如果支付失败,可以通过result.statusCode查询错误码
        else {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"支付失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            //通知传值
            NSDictionary * dict = @{@"result":@"NO"};
            if (notification == nil) {
                notification = [NSNotification notificationWithName:@"zhifubaoPay" object:nil userInfo:dict];
            }
            //用通知中心发送
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
    AlixPayResult * result = nil;
    
    if (url != nil && ([[url host] compare:@"safepay"] == 0 || [url.host isEqualToString:@"platformapi"])) {
        result = [self resultFromURL:url];
    }
    
    return result;
}

- (AlixPayResult *)resultFromURL:(NSURL *)url {
    NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
    return [[AlixPayResult alloc] initWithString:query];
}


//TODO:微信支付返回结果
-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSLog(@"%d",resp.errCode);
        switch (resp.errCode) {
                
            case WXSuccess:
            {
                //通知传值
                NSDictionary * dict = @{@"result":@"YES"};
                if (notification == nil) {
                    
                    notification = [NSNotification notificationWithName:@"zhifubaoPay" object:nil userInfo:dict];
                }
                
                //用通知中心发送
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            }
                break;
                
            default:
            {
                //通知传值
                NSDictionary * dict = @{@"result":@"NO"};
                if (notification == nil) {
                    
                    notification = [NSNotification notificationWithName:@"zhifubaoPay" object:nil userInfo:dict];
                }
                
                //用通知中心发送
                [[NSNotificationCenter defaultCenter] postNotification:notification];
               
            }
                break;
        }
    }
    
}


/***************************************************/

@end
