//
//  ChoosePayTypeVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ChoosePayTypeVC.h"

#import "ExmapleWorkDetailVC.h"

#import "AlipayMethod.h"
#import "payRequsestHandler.h"
#import "WXApi.h"

#import "PayFailureVC.h"
#import "PaySuccessfulVC.h"

typedef enum{
  
    AliPay_type,   //支付宝
    WechatPay_type, //微信支付
    QuckilyPay_type, //快钱
    PublicPay_type   //公益兑换
   
}PayType;

@interface ChoosePayTypeVC ()
{
    NSInteger _payType; //支付方式
}
@end

@implementation ChoosePayTypeVC

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"支付方式";
    [self setNavBackBtnWithType:1];
    
    
}
/*返回的时候直接跳到样品详情*/
- (void)backBtnClick
{
    for (BaseSuperViewController *detail in self.navigationController.viewControllers)
    {
        if([detail isKindOfClass:[ExmapleWorkDetailVC class]])
        {
            [self.navigationController popToViewController:detail animated:YES];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*监听支付宝操作结果通知*/
    [mNotificationCenter addObserver:self selector:@selector( AliPayResult:) name:@"zhifubaoPay" object:nil];
    
    
    [self createPayTypeChooseItem];
}

#pragma mark -- 选择项
- (void)createPayTypeChooseItem
{
//  NSArray *titleArr = @[@"支付宝支付",@"微信支付",@"快钱支付",@"让书法回家公益兑换"];
    NSArray *titleArr;
    CGFloat itemH = 40;
    
    /*如果开启了公益活动，且是有兑换资格,还得是公益产品*/
    BOOL isFree = [[PersonalInfoSingleModel shareInstance].IsFreeQualify isEqualToString:@"1"]&&[[[PublicWelfareManager shareInstance] getPublicWelfareState] isEqualToString:@"1"]
    ;
    if(isFree)
    {
       titleArr = @[@"支付宝支付",@"微信支付",@"让书法回家公益兑换"];
        /*提示*/
        [self createTipsLabWithFrame:mRect(25, itemH*(titleArr.count+0.5), mScreenWidth-50, 50)];
    }else{
    
       titleArr = @[@"支付宝支付",@"微信支付"];
    }
    for(NSInteger i=0;i<titleArr.count;i++)
    {
        UIView *itemView = [self chooseItemTemplateWithFrame:mRect(0, i*itemH, kkDeviceWidth, itemH) TitleName:titleArr[i] ButtonTag:2100+i IsChoosed:i==0?YES:NO];
        [self.view addSubview:itemView];
    }
    
    /*立即支付按钮*/
    [self createPayNowButtonWithFrame:mRect(25,(titleArr.count+(isFree?2.0:0.7))*itemH, kkDeviceWidth-50, 45)];

}

/*模板*/
- (UIView*)chooseItemTemplateWithFrame:(CGRect)frame
                          TitleName:(NSString*)TitleStr
                            ButtonTag:(NSInteger)tag
                           IsChoosed:(BOOL)isChoose
{
    UIView *view  = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLab = [XHDHelper createLabelWithFrame:mRect(25, 5, 180, frame.size.height-10) andText:TitleStr andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [view addSubview:titleLab];
    
    UIButton *selectButton = [XHDHelper createButton:mRect(frame.size.width-180,2.5,200,40) NomalTitle:@"" SelectedTitle:nil NomalTitleColor:nil SelectTitleColor:nil NomalImage:nil SelectedImage:mImageByName(@"gou_red_sample") BoardLineWidth:0 target:self selector:@selector(choosePayType:)];
    [selectButton setImageEdgeInsets:UIEdgeInsetsMake(0,0, 0,-100)];
    selectButton.selected = isChoose;
    selectButton.tag = tag;
    [view addSubview:selectButton];
    
    [XHDHelper addDivLineWithFrame:mRect(0, view.height-0.5, view.width, 0.5) SuperView:view];

    return view;
}
/*支付类型选择动作*/
- (void)choosePayType:(UIButton*)sender
{
    for(NSInteger i =2100; i<=2102;i++)
    {
        UIButton *bnt = (UIButton *)[self.view viewWithTag:i];
        bnt.selected = NO;
    }
    sender.selected = YES;
    if(sender.tag == 2100)
    {
        _payType  = AliPay_type;
        
    }else if(sender.tag == 2101)
    {
        _payType  = WechatPay_type;
        
    }else if(sender.tag == 2102){
        
        _payType = PublicPay_type;
        
    }else if(sender.tag == 2103)
    {
        _payType = QuckilyPay_type;
        
    }
}
#pragma mark -- 注释
-(void)createTipsLabWithFrame:(CGRect)frame
{
    UILabel *tipsLab = [XHDHelper createLabelWithFrame:frame andText:@"本次公益活动只提供轴裱和托裱服务，订单中选择框裱或轴裱方式的统一视为选择轴裱，选择其他或无裱方式的统一视为托裱。" andFont:UIFONT(12) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.numberOfLines = 3;
    [self.view addSubview:tipsLab];

}
#pragma mark -- 立即支付按钮
- (void)createPayNowButtonWithFrame:(CGRect)frame
{
    UIButton *payNowBnt = [XHDHelper getRedGeneralButtonWithFrame:frame AndTitleString:@"立即支付"];
    payNowBnt.layer.cornerRadius = 3;
    payNowBnt.clipsToBounds = YES;
    [payNowBnt addTarget:self action:@selector(payNowAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payNowBnt];
}

- (void)payNowAction:(UIButton*)sender
{
    switch (_payType) {
        case AliPay_type:  //支付宝
        {
            [[AlipayMethod shareAlipayMethod] alipayWithGoodsName:@"墨品支付" OrderID:_orderCode Amount:_Amount];
        }
            break;
        case WechatPay_type://微信支付
        {
            
            [self requestWechatPayID];
        }
            break;
        case QuckilyPay_type://快钱支付
        {
            
        }
            break;
        case PublicPay_type://公益兑换
        {
            [self PublicWelfarePay];
        }
            break;
            
        default:
            break;
    }

}


#pragma mark -- 支付相关
//TODO:从服务器请求微信预支付ID
- (void)requestWechatPayID
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    
        [parameterDic setValue:@"WechatPay" forKey:@"Method"]; //微信支付
        [parameterDic setValue:Infversion forKey:@"Infversion"];
        [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];//用户ID
        [parameterDic setValue:_orderCode forKey:@"OrderCode"];//订单ID
    
        [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            
            //获取微信预支付ID，调用微信支付
            NSDictionary * dataDic = jsonObject[@"data"];
            [self WeChatSendPay:dataDic[@"WechatPayID"]];
            
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
        
        NSLog(@"%@",error);
        
    }];
    
}


#pragma mark -- 微信支付
- (void)WeChatSendPay:(NSString *)WechatPayID
{
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    [req init:WeiXin_APP_ID mch_id:WeiXin_MCH_ID];
    //设置密钥
    [req setKey:WeiXin_PARTNER_ID];
    
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    
    nonce_str	= [WXUtil md5:time_stamp];
    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
    //package   = [NSString stringWithFormat:@"Sign=%@",package];
    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: WeiXin_APP_ID        forKey:@"appid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: WeiXin_PARTNER_ID        forKey:@"partnerid"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    [signParams setObject: WechatPayID     forKey:@"prepayid"];
   // [signParams setObject: @"MD5"       forKey:@"signType"];
    
    //生成签名
    NSString *sign  = [req createMd5Sign:signParams];
    //添加签名
    [signParams setObject: sign         forKey:@"sign"];
    
    
    //调起微信支付
    PayReq* payreq             = [[PayReq alloc] init];
    payreq.openID              = [signParams objectForKey:@"appid"];
    payreq.partnerId           = [signParams objectForKey:@"partnerid"];
    payreq.prepayId            = [signParams objectForKey:@"prepayid"];
    payreq.nonceStr            = [signParams objectForKey:@"noncestr"];
    payreq.timeStamp           = [[signParams objectForKey:@"timestamp"]intValue];
    payreq.package             = [signParams objectForKey:@"package"];
    payreq.sign                = [signParams objectForKey:@"sign"];
    
    [WXApi sendReq:payreq];
    
}

//TODO:微信支付返回结果
-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSLog(@"-------%@",strMsg);
    NSString *strTitle;
    
    if([resp isKindOfClass:[PayResp class]]){
        
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
                
            case WXSuccess:
            {
                //支付成功，跳转支付成功界面
                [self paySuccess];
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            }
                break;
                
            default:
            {
               
                //支付失败，跳转支付失败界面
                [self payFailure];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            }
                break;
        }
    }
    
}



#pragma mark -- 处理支付宝支付结果
- (void)AliPayResult:(NSNotification *)noti
{
    NSDictionary * infoDic = noti.userInfo;
    BOOL result = [infoDic[@"result"] boolValue];
    if (result) {
        
        //支付成功，跳转支付成功界面
        [self paySuccess];
        
    }
    else
    {
        //支付失败，跳转支付失败界面
       [self payFailure];
    }
}
#pragma mark -- 公益兑换
- (void)PublicWelfarePay
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    
    [parameterDic setValue:@"PublicGoodPay" forKey:@"Method"]; //公益支付
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];//用户ID
    [parameterDic setValue:_orderCode forKey:@"OrderCode"];//订单ID
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            
            //本地也要改变公益兑换资格
            [PersonalInfoSingleModel saveValueWithKey:@"IsFreeQualify" andValue:@"0"];
            
            //支付成功
            [self paySuccess];
            
        }else{
            //支付失败
            [self payFailure];
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
        
        NSLog(@"%@",error);
        
    }];

}


//TODO:支付成功后的跳转
- (void)paySuccess
{
        PaySuccessfulVC *sucesse = [[PaySuccessfulVC alloc]initWithSJCoupon:_SJCoupon InviteFriend:_InviteFriend IFReturn:_IFReturn OrderShare:_OrderShare];
    [mNotificationCenter postNotificationName:@"updateMyOrderList" object:nil userInfo:nil];
        [self.navigationController pushViewController:sucesse animated:YES];
}
//TODO:支付失败
- (void)payFailure
{
    PayFailureVC *fail = [[PayFailureVC alloc]init];
    [self.navigationController pushViewController:fail animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
