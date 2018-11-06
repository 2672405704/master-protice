//
//  ComfireOrderVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ComfireOrderVC.h"
#import "ChoosePayTypeVC.h"

#import "AddressVeiw_zero.h"
#import "WorkInfoView_first.h"
#import "OrderInfoView_second.h"
#import "OrderPriceView.h"
#import "ZhuanBiaoAndWuLiuView.h"
#import "TotalPayView.h"
#import "FaPiaoInfoView.h"


#import "MoveJJViewController.h"
#import "AddressViewController.h"
#import "BillDetailVC.h"


@class InfoItemView;

@interface ComfireOrderVC ()<chooseJuanDelegate,GotoFillFaPiaoInfoDelegate>
{
    UIScrollView *_bgScrollView;
    UIButton *_payNowBnt;  //立即支付按钮
    AddressVeiw_zero *addressVeiw_zero; //地址
    WorkInfoView_first *workInfo_first;//作品信息
    OrderInfoView_second *orderInfoView_second;//订购信息
    OrderPriceView* orderPriceView_third; //支付价格
    ZhuanBiaoAndWuLiuView *zhuanBiaoWuliuView_third;//装裱物流价格
    TotalPayView *totalPayView_third;//实付价格
    FaPiaoInfoView *faPiaoInfoView_third; //选择发票信息
    
}

@end

/**要在这个界面处理的订单参数
 
 userID
 AddressID
 OrderNum
 Remark
 SJCouponUsed
 MPCouponUsed
 ReceiptContent
 Amount
 
 */

@implementation ComfireOrderVC
{
    __weak ComfireOrderVC *WeakSelf;
}

- (instancetype)initWithMod:(OrderRequestModel*)mod
{
    self = [super init];
    if (self) {
        
        _orderMod = mod;
        [self createBackGroundView];
        [self createPayNowButton];
        
        
    }
    return self;
}

#pragma mark --创建背景滑动
- (void)createBackGroundView
{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, kkDeviceHeight-64)];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.contentSize = CGSizeMake(0, 960);
    [self.view addSubview:_bgScrollView];
}

#pragma mark -- 立即支付按钮
- (void)createPayNowButton
{
    _payNowBnt = [XHDHelper getRedGeneralButtonWithFrame:mRect(0, _bgScrollView.contentSize.height-kkSureButtonH, kkDeviceWidth, kkSureButtonH) AndTitleString:@"立即支付"];
    [_bgScrollView addSubview:_payNowBnt];
    [_payNowBnt addTarget:self action:@selector(goToPayViewController:) forControlEvents:UIControlEventTouchUpInside];

}
/*跳转到支付选择界面 === 确认下单*/
-(void)goToPayViewController:(UIButton*)sender
{
    /*判空*/
    if(_orderMod.AddressID.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择收货地址"];
        return;
    }
    if(_orderMod.OrderNum.length==0 || [_orderMod.OrderNum isEqualToString:@"0"] )
    {
        [SVProgressHUD showErrorWithStatus:@"请输入订单数量"];
        return;
    }
    
    [self requestData];

}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"确认订单";
    [self setNavBackBtnWithType:1];
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addressHeaderView];
    [self getDefaultAddress];
    [self workInfoView];
    [self buyCarInfoView];
    [self payInfoView];
}


#pragma mark -- 地址段
- (void)addressHeaderView
{
    addressVeiw_zero = [[AddressVeiw_zero alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, 80) AddressMod:_addMod];
    [addressVeiw_zero addTarget:self action:@selector(chooseAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgScrollView addSubview:addressVeiw_zero];

}
/*跳转到选择地址*/
- (void)chooseAddressAction:(UIControl*)sender
{
    AddressViewController *chooseAddress = [[AddressViewController alloc]init];
    chooseAddress.fromComfireOrderVC = 1;
    chooseAddress.finishChooseAddress = ^(AddressModel*mod){
        
        addressVeiw_zero.mod = mod;
        _orderMod.AddressID = mod.Addressid;  //填充地址ID
        _orderMod.Address = mod.Address;
        _orderMod.Mobile = mod.Mobile;
        _orderMod.Name = mod.Name;
        
        [WeakSelf updateUI];
    };
    [self.navigationController pushViewController:chooseAddress animated:YES];
}

#pragma mark -- 作品信息段
- (void)workInfoView
{
    //第一段
    UIView* headerView_first = [self createCommonTitleViewWithOriginY:80 andTitleStr:@"作品信息"];
    [_bgScrollView addSubview:headerView_first];
    
    workInfo_first = [[WorkInfoView_first alloc]initWithFrame:mRect(0, headerView_first.bottom, kkDeviceWidth, 410)];
    
    workInfo_first.mod = _orderMod;
    workInfo_first.delegate = self;
    
    [_bgScrollView addSubview:workInfo_first];

}
#pragma mark --订购信息
- (void)buyCarInfoView
{
    //第一段
    UIView* headerView_second = [self createCommonTitleViewWithOriginY:workInfo_first.bottom andTitleStr:@"订单信息"];
    [_bgScrollView addSubview:headerView_second];
    
    //订购数量以及买家留言
    orderInfoView_second = [[OrderInfoView_second alloc]initWithFrame:mRect(0,headerView_second.bottom, kkDeviceWidth, 80)];
    orderInfoView_second.delegate = self;
    orderInfoView_second.chooseNumber = @"1";/*暂时写死*/
    orderInfoView_second.liuYanStr = @"";
    [_bgScrollView addSubview:orderInfoView_second];
    
    _orderMod.OrderNum = @"1";  //TODO:订单数量
    _orderMod.Remark  = orderInfoView_second.liuYanStr; //买家留言
    

}
#pragma mark --支付信息
- (void)payInfoView
{
    UIView* headerView_third = [self createCommonTitleViewWithOriginY:orderInfoView_second.bottom andTitleStr:@"支付信息"];
    [_bgScrollView addSubview:headerView_third];
    
    
    //TODO:支付信息
    orderPriceView_third = [[OrderPriceView alloc]initWithFrame:mRect(0, headerView_third.bottom, kkDeviceWidth, 80)];
    orderPriceView_third.priceStr = [NSString stringWithFormat:@"%@",_orderMod.Price.length?_orderMod.Price:@"0.00"];
    orderPriceView_third.SjJuan =  _orderMod.canUseSjJuan.length?_orderMod.canUseSjJuan:@"";
     orderPriceView_third.MpJuan =  _orderMod.canUseMpJuan.length?_orderMod.canUseMpJuan:@"";
    orderPriceView_third.delegate = self;
    [orderPriceView_third SetDisPlayVeiw];
     [_bgScrollView addSubview:orderPriceView_third];
    
    //TODO:装裱价格以及物流快递的价格
    zhuanBiaoWuliuView_third = [[ZhuanBiaoAndWuLiuView alloc]initWithFrame:mRect(0, orderPriceView_third.bottom+10, kkDeviceWidth, 40)];
    /*
     注:物流费用改了需求，不在需要了，置换为0就可以了，有需要再改
     */
    zhuanBiaoWuliuView_third.wuliuPrice = @"0.00"; //物流价格
    zhuanBiaoWuliuView_third.zhuanBiaoPrice = _orderMod.ZhuanBiaoPrice;  //装裱价格
    [zhuanBiaoWuliuView_third _initUI];
    [_bgScrollView addSubview:zhuanBiaoWuliuView_third];
    
    
    /*实付*/
    totalPayView_third = [[TotalPayView alloc]initWithFrame:mRect(0, zhuanBiaoWuliuView_third.bottom+10, kkDeviceWidth, 40)];
    
    /*实付金额 = 作品金额+装裱金额+物流金额-用劵折扣*/
    totalPayView_third.priceStr = [NSString stringWithFormat:@"%lf",zhuanBiaoWuliuView_third.wuliuPrice.floatValue + zhuanBiaoWuliuView_third.zhuanBiaoPrice.floatValue +_orderMod.Price.floatValue - orderPriceView_third.usedTotalAmount.floatValue];

    [_bgScrollView addSubview:totalPayView_third];
    
    /*发票信息*/
    faPiaoInfoView_third = [[FaPiaoInfoView alloc]initWithFrame:mRect(0, totalPayView_third.bottom+10, kkDeviceWidth, 40)];
    faPiaoInfoView_third.delegate = self;
    [_bgScrollView addSubview:faPiaoInfoView_third];
}

/*去选劵*/
- (void)toChooseJuan
{
    
    //是否开启了公益
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState]isEqualToString:@"1"])
    {
        //判断是否具有资格
        if([[PersonalInfoSingleModel shareInstance].IsFreeQualify isEqualToString:@"1"]&& [_orderMod.IsPublicGoodSample isEqualToString:@"1"])
        {
            [SVProgressHUD showImage:nil status:@"不用使用墨品劵"];
            return;
        }
        
    }
    
    
        MoveJJViewController *movJ = [[MoveJJViewController alloc]init];
        /*带入可用书家劵的基本信息*/
        movJ.PMIDofArt = _orderMod.PenManID; //书家ID
    
        movJ.moPinText = _orderMod.canUseMpJuanAmount;  //可用书家劵
        movJ.shuJiaText = _orderMod.canUseSjJuanAmount; //可用墨品劵
        
        movJ.selectMoPinJuanIDString = _orderMod.MPCouponUsed;
        movJ.selectShuJiaJuanIDString = _orderMod.SJCouponUsed;
        
        
        /*清空使用劵*/
        movJ.emptyChoosedId = ^{
            
            orderPriceView_third.usedMpJuan = @"0.00";
            _orderMod.MPCouponUsed = @"";
            orderPriceView_third.usedSjJuan=@"0.00";
            _orderMod.SJCouponUsed = @"";
            //赋值，刷新UI，拼串
            orderPriceView_third.usedMpJuan = @"0.00";
            orderPriceView_third.usedSjJuan = @"0.00";
            orderPriceView_third.usedTotalAmount =@"0.00";
            
            
            [orderPriceView_third setFinishedChooseDisplayView];
            
            totalPayView_third.priceStr = [NSString stringWithFormat:@"%.2f",zhuanBiaoWuliuView_third.wuliuPrice.floatValue + zhuanBiaoWuliuView_third.zhuanBiaoPrice.floatValue +_orderMod.Price.floatValue - orderPriceView_third.usedTotalAmount.floatValue];
            
            [orderPriceView_third setFinishedChooseDisplayView];
            
            orderPriceView_third.height = 155;
            zhuanBiaoWuliuView_third.top = orderPriceView_third.bottom+10;
            totalPayView_third.top  = zhuanBiaoWuliuView_third.bottom+10;
            faPiaoInfoView_third.top = totalPayView_third.bottom+10;
            _bgScrollView.contentSize = CGSizeMake(kkDeviceWidth, 1080);
            _payNowBnt.bottom = 1080;
            
        };
        
        /*完成劵的使用*/
        movJ.finishChooseJuan = ^(NSString *MPJAmout,NSString *SJJAmout,NSMutableArray*MPJ_IDArr,NSMutableArray*SJJ_IDArr){
            
            /*墨品劵折扣后的价格*/
            CGFloat MpAfterCount = _orderMod.Price.floatValue*(_orderMod.canUseMpJuan. floatValue)/100.0f;/*总价能用的墨品劵部分*/
            
            MpAfterCount = MpAfterCount<=MPJAmout.floatValue?MpAfterCount:MPJAmout.floatValue;
            
            orderPriceView_third.usedMpJuan = [NSString stringWithFormat:@"%.2f",MpAfterCount];
            
            /*书家劵折扣后的价格*/
            CGFloat SjAfterCount = _orderMod.Price.floatValue*(_orderMod.canUseSjJuan.floatValue)/100.0f;
            
            SjAfterCount = SjAfterCount<=SJJAmout.floatValue?SjAfterCount:SJJAmout.floatValue;
            
            orderPriceView_third.usedSjJuan = [NSString stringWithFormat:@"%.2f",SjAfterCount];
            
            /*折扣*/
            orderPriceView_third.usedTotalAmount = [NSString stringWithFormat:@"%.2lf",SjAfterCount+MpAfterCount];
            
            /*实付金额 = 作品金额+装裱金额+物流金额-用劵折扣*/
            totalPayView_third.priceStr = [NSString stringWithFormat:@"%.2f",zhuanBiaoWuliuView_third.wuliuPrice.floatValue + zhuanBiaoWuliuView_third.zhuanBiaoPrice.floatValue +_orderMod.Price.floatValue - orderPriceView_third.usedTotalAmount.floatValue];
            
            [orderPriceView_third setFinishedChooseDisplayView];
            
            orderPriceView_third.height = 155;
            zhuanBiaoWuliuView_third.top = orderPriceView_third.bottom+10;
            totalPayView_third.top  = zhuanBiaoWuliuView_third.bottom+10;
            faPiaoInfoView_third.top = totalPayView_third.bottom+10;
            _bgScrollView.contentSize = CGSizeMake(kkDeviceWidth, 1040);
            _payNowBnt.bottom = 1040;
            
            //拼串
            NSString *MpID = @"";
            for(NSString *subStr in MPJ_IDArr)
            {
                MpID = [MpID stringByAppendingString:[NSString stringWithFormat:@"%@,",subStr]];
            }
            _orderMod.MPCouponUsed = MpID;  //墨品劵ID
            
            NSString *SjID = @"";
            for(NSString *subStr in SJJ_IDArr)
            {
                SjID = [SjID stringByAppendingString:[NSString stringWithFormat:@"%@,",subStr]];
            }
            _orderMod.SJCouponUsed = SjID; //书家劵ID
            
        };
        
        
        [self.navigationController pushViewController:movJ animated:YES];
    

    
}

/*去填发票信息*/
- (void)gotoFillFaPiaoInfo
{
    //如果有兑换资格就不让开发票
    //是否开启了公益
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState]isEqualToString:@"1"])
    {
        //判断是否具有资格
        if([[PersonalInfoSingleModel shareInstance].IsFreeQualify isEqualToString:@"1"]&& [_orderMod.IsPublicGoodSample isEqualToString:@"1"])
        {
             [SVProgressHUD showImage:nil status:@"不能开相关发票"];
            return;
        }
        
    }
    
        __weak typeof(self)weakSelf  = self;
        BillDetailVC *billDetail = [[BillDetailVC alloc]initWithNibName:@"BillDetailVC" bundle:[NSBundle mainBundle]];
        billDetail.fromMark = 2;
        
        /*填充带入的内容*/
        billDetail.titleName = _orderMod.ReceiptContent;  //抬头
        billDetail.wuliuPrice = @"25";
        billDetail.ZhuanBiaoPrice = _orderMod.ZhuanBiaoPrice.length?_orderMod.ZhuanBiaoPrice:@"0.00";
        
        billDetail.finishFill = ^(NSString *billContent)
        {
            
            faPiaoInfoView_third.faPiaoContent = billContent;
            [faPiaoInfoView_third _initUI];
            weakSelf.orderMod.ReceiptContent = billContent; //发票内容
        };
        
        [weakSelf.navigationController pushViewController:billDetail animated:YES];
    

}


#pragma mark -- 更新UI
-(void) updateUI
{
    [addressVeiw_zero setNeedsLayout];
    [orderInfoView_second updateUI];
}


#pragma mark -- 网络请求(提交订单)
/*提交订单*/
- (void)requestData
{
    /*判断是不是自己购买自己的产品*/
    if([[PersonalInfoSingleModel shareInstance].UserID isEqualToString:_orderMod.PenManID])
    {
        [SVProgressHUD showErrorWithStatus:@"请不要定制自己的墨品，谢谢合作！"];
        return;
    }
    /*如果金额是0，则以0.01元支付*/
    if(totalPayView_third.priceStr.floatValue == 0.0f)
    {
        totalPayView_third.priceStr = @"0.01";
        [SVProgressHUD showImage:nil status:@"订单合计为0元，系统默认要求支付0.01元"];
    
    }
    
    _orderMod.Amount = totalPayView_third.priceStr;
    _orderMod.Remark  = orderInfoView_second.liuYanStr;
    if([_orderMod.ZhBType isEqualToString:@"3"])
    {
        _orderMod.ZhBStyleID = @"";
    }
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SubmitOrder" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:_orderMod.AddressID forKey:@"AddressID"];
    [parameterDic setValue:_orderMod.ArtID forKey:@"ArtID"];
    [parameterDic setValue:_orderMod.Content forKey:@"Content"];
    [parameterDic setValue:_orderMod.IsTiKuan forKey:@"IsTiKuan"];
    if(_orderMod.TKContent.length)
    {
        [parameterDic setValue:_orderMod.TKContent forKey:@"TKContent"];
    }
    [parameterDic setValue:_orderMod.ZhBType forKey:@"ZhBType"];
    [parameterDic setValue:_orderMod.ZhBStyleID forKey:@"ZhBStyleID"];
    [parameterDic setValue:_orderMod.OrderNum forKey:@"OrderNum"];
    [parameterDic setValue:_orderMod.Remark.length?_orderMod.Remark:@"" forKey:@"Remark"];
    [parameterDic setValue:_orderMod.SJCouponUsed.length? _orderMod.SJCouponUsed:@"" forKey:@"SJCouponUsed"];
    [parameterDic setValue:_orderMod.MPCouponUsed.length?_orderMod.MPCouponUsed:@"" forKey:@"MPCouponUsed"];
    [parameterDic setValue:_orderMod.ReceiptContent forKey:@"ReceiptContent"];
    [parameterDic setValue:_orderMod.Amount forKey:@"Amount"];
    
    [parameterDic setValue:_orderMod.Place forKey:@"Place"];
    [parameterDic setValue:_orderMod.wordType forKey:@"WordType"];
    [parameterDic setValue:_orderMod.showType forKey:@"ShowType"];
    [parameterDic setValue:_orderMod.size forKey:@"Size"];
    [parameterDic setValue:_orderMod.Name forKey:@"Name"];
    [parameterDic setValue:_orderMod.Mobile forKey:@"Mobile"];
    [parameterDic setValue:_orderMod.Address forKey:@"Address"];
    [parameterDic setValue:_orderMod.IsPublicGoodSample forKey:@"IsPublicGoodSample"]; //是否是公益作品
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
            /*订单确认成功，跳转到确认支付界面*/
            ChoosePayTypeVC *choosePay = [ChoosePayTypeVC new];
            choosePay.orderCode = jsonObject[@"data"][0][@"OrderCode"];
            choosePay.IFReturn = jsonObject[@"data"][0][@"IFReturn"];
            choosePay.InviteFriend = jsonObject[@"data"][0][@"InviteFriend"];
            choosePay.OrderShare = jsonObject[@"data"][0][@"OrderShare"];
            choosePay.SJCoupon = jsonObject[@"data"][0][@"SJCoupon"];
            choosePay.Amount = _orderMod.Amount;
            [self.navigationController pushViewController:choosePay animated:YES];
            
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"很抱歉,定制失败！"];
        NSLog(@"%@",error);
       
    }];
    
}

/*获取默认地址*/
-(void)getDefaultAddress
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetAddressList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
           /*获取默认地址*/
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                AddressModel *mod = [[AddressModel alloc]init];
                [mod setValuesForKeysWithDictionary:dic];
                if([mod.IsDefault isEqualToString:@"1"])
                {
                    addressVeiw_zero.mod = mod;
                    _orderMod.AddressID = mod.Addressid;  //填充地址ID
                    _orderMod.Address = mod.Address;
                    _orderMod.Mobile = mod.Mobile;
                    _orderMod.Name = mod.Name;
                    [addressVeiw_zero setNeedsLayout];
                }
                
            }
            
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark -- 公用界面-------------ok
-(UIView*)createCommonTitleViewWithOriginY:(CGFloat)originY  andTitleStr:(NSString*)title
{
    UIView *bgView = [[UIView alloc]initWithFrame:mRect(0, originY, kkDeviceWidth, 35)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabe = [XHDHelper createLabelWithFrame:mRect(20, 0, kkDeviceWidth-60, 35) andText:title andFont:UIFONT_Tilte(15) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    
    [bgView addSubview:titleLabe];
    return bgView;
}

@end


