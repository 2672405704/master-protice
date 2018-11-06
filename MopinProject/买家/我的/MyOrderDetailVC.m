//
//  MyOrderDetailVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/21.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "MyOrderDetailVC.h"

#import "AddressModel.h"
#import "OrderRequestModel.h"

#import "AddressVeiw_zero.h" //地址
#import "WorkInfoView_first.h"  //作品信息
#import "OrderInfoView_second.h" //订单信息
#import "OrderPriceView.h"  //支付信息
#import "ZhuanBiaoAndWuLiuView.h" //装裱
#import "TotalPayView.h"  //实付
#import "FaPiaoInfoView.h" //发票

#import "BillDetailVC.h"
#import "MyOrderDetailModel.h"

@interface MyOrderDetailVC ()<GotoFillFaPiaoInfoDelegate>
{
    UIScrollView *_bgScrollView;
    AddressVeiw_zero *addressVeiw_zero; //地址
    WorkInfoView_first *workInfo_first;//作品信息
    OrderInfoView_second *orderInfoView_second;//订购信息
    OrderPriceView* orderPriceView_third; //支付价格
    ZhuanBiaoAndWuLiuView *zhuanBiaoWuliuView_third;//装裱物流价格
    TotalPayView *totalPayView_third;//实付价格
    FaPiaoInfoView *faPiaoInfoView_third; //选择发票信息
}

@property(nonatomic,strong)MyOrderDetailModel *mod;

@end

@implementation MyOrderDetailVC
- (instancetype)initWithOrderCode:(NSString*)code FormType:(NSString*)type
{
  if(self = [super init])
  {
      _orderCode = code;
      _formType = type;
      [self createBackGroundView];
      [self requestData];
      _mod = [[MyOrderDetailModel alloc]init];
  }
    return self;
}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"我的定制";
    [self setNavBackBtnWithType:1];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self addOrderCodeDisplayViewAndStatus];
    [self addressHeaderView];
    [self workInfoView];
    [self buyCarInfoView];
    [self payInfoView];
    [self createBottomButton];

}
#pragma mark - 返回按钮
- (void)backBtnClick
{
    if(_isDismiss){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [super backBtnClick];
    }
}
#pragma mark -- 背景
- (void)createBackGroundView
{
    _bgScrollView = [[UIScrollView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, kkDeviceHeight-64)];
    _bgScrollView.showsVerticalScrollIndicator = NO;
    _bgScrollView.contentSize = CGSizeMake(0, 990);
    [self.view addSubview:_bgScrollView];
}
#pragma mark -- 订单号和转态
- (void) addOrderCodeDisplayViewAndStatus
{
    UIView *orderCodeBg = [[UIView alloc]initWithFrame:mRect(0, 0, kkDeviceHeight, 40)];
    orderCodeBg.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:orderCodeBg];
    
    //订单号：
    UILabel *orderCodeContent = [XHDHelper createLabelWithFrame:mRect(25, 5, 170, 30) andText:[NSString stringWithFormat:@"订单号:%@",_orderCode.length?_orderCode:@"00000000"] andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    // orderCodeContent.text = @"";
    [orderCodeBg addSubview:orderCodeContent];
    
    
    //订单转态
    UILabel *orderStatusLab = [XHDHelper createLabelWithFrame:mRect(25, 5, 100, 30) andText:[NSString stringWithFormat:@"未支付%@",@""] andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
    orderStatusLab.right = orderCodeBg.width-25;
    orderStatusLab.textAlignment = NSTextAlignmentRight;
    [orderCodeBg addSubview:orderStatusLab];
}

#pragma mark -- 地址
- (void)addressHeaderView
{
    AddressModel *addMod = [[AddressModel alloc]init];
    addressVeiw_zero = [[AddressVeiw_zero alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, 80) AddressMod:addMod];
    addressVeiw_zero.isShowRightArrow = NO;
    [_bgScrollView addSubview:addressVeiw_zero];
}
#pragma mark -- 订单信息
- (void)workInfoView
{
    //第一段
    UIView* headerView_first = [self createCommonTitleViewWithOriginY:80 andTitleStr:@"作品信息"];
    [_bgScrollView addSubview:headerView_first];
    
    workInfo_first = [[WorkInfoView_first alloc]initWithFrame:mRect(0, headerView_first.bottom, kkDeviceWidth, 410)];
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
    
    /*要能点进去查看留言*/
     orderInfoView_second.enableCheck = NO;
    orderInfoView_second.delegate = self;
    [_bgScrollView addSubview:orderInfoView_second];
}
#pragma mark --支付信息
- (void)payInfoView
{
    UIView* headerView_third = [self createCommonTitleViewWithOriginY:orderInfoView_second.bottom andTitleStr:@"支付信息"];
    [_bgScrollView addSubview:headerView_third];
    
#pragma mark -- 支付信息
    orderPriceView_third = [[OrderPriceView alloc]initWithFrame:mRect(0, headerView_third.bottom, kkDeviceWidth, 80)];
    [orderPriceView_third setFinishedChooseDisplayView];
    [_bgScrollView addSubview:orderPriceView_third];
    
#pragma mark -- 装裱价格以及物流快递的价格
    zhuanBiaoWuliuView_third = [[ZhuanBiaoAndWuLiuView alloc]initWithFrame:mRect(0, orderPriceView_third.bottom+10, kkDeviceWidth, 40)];
    zhuanBiaoWuliuView_third.wuliuPrice = _mod.Deliver; //物流价格
    zhuanBiaoWuliuView_third.zhuanBiaoPrice = _mod.Packprice;  //装裱价格
    [zhuanBiaoWuliuView_third _initUI];
    [_bgScrollView addSubview:zhuanBiaoWuliuView_third];
    
    
#pragma mark -- 实付
    totalPayView_third = [[TotalPayView alloc]initWithFrame:mRect(0, zhuanBiaoWuliuView_third.bottom+10, kkDeviceWidth, 40)];
    totalPayView_third.priceStr =_mod.Amount;
    [_bgScrollView addSubview:totalPayView_third];
    
#pragma mark -- 发票
    faPiaoInfoView_third = [[FaPiaoInfoView alloc]initWithFrame:mRect(0, totalPayView_third.bottom+10, kkDeviceWidth, 40)];
    faPiaoInfoView_third.faPiaoContent = _mod.Receiptcontent;
    [faPiaoInfoView_third _initUI];
    faPiaoInfoView_third.delegate = self;
    [_bgScrollView addSubview:faPiaoInfoView_third];
}
/*查看发票信息*/
- (void)gotoFillFaPiaoInfo
{
    BillDetailVC *billDetail = [[BillDetailVC alloc]initWithNibName:@"BillDetailVC" bundle:[NSBundle mainBundle]];
    billDetail.fromMark = 1;
    /*填充带入的内容*/
    billDetail.titleName = _mod.Receiptcontent;  //抬头
    billDetail.wuliuPrice = _mod.Deliver.length?_mod.Deliver:@"0.00";
    billDetail.ZhuanBiaoPrice = _mod.Packprice.length?_mod.Packprice:@"0.00";
    billDetail.enableEidt = NO;
    [self.navigationController pushViewController:billDetail animated:YES];

}
#pragma mark  -- 下面四个按钮
- (void)createBottomButton
{

}


#pragma mark -- 公用界面-------------
-(UIView*)createCommonTitleViewWithOriginY:(CGFloat)originY  andTitleStr:(NSString*)title
{
    UIView *bgView = [[UIView alloc]initWithFrame:mRect(0, originY, kkDeviceWidth, 35)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabe = [XHDHelper createLabelWithFrame:mRect(20, 0, kkDeviceWidth-60, 35) andText:title andFont:UIFONT_Tilte(15) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    
    [bgView addSubview:titleLabe];
    return bgView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 请求网络
- (void)requestData
{
    [SVProgressHUD showWithStatus:@"正在努力加载中..."];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"OrderDetail" forKey:@"Method"];
    
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_orderCode forKey:@"OrderCode"];
    
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        
        [SVProgressHUD dismiss];
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
           for(NSDictionary *dic in jsonObject[@"data"])
           {
              [_mod setValuesForKeysWithDictionary:dic];
           
           }
            
        }
        [self updataUI];
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}

/*网路请求完后，刷新数据*/
- (void)updataUI
{
    /*地址*/
    if([_formType isEqualToString:@"1"])
    {
        addressVeiw_zero.mod.Mobile = _mod.Mobile;
        addressVeiw_zero.mod.Address = _mod.Address;
        addressVeiw_zero.mod.Name = _mod.Name;
        [addressVeiw_zero setNeedsLayout];
        
    }else{
        
        addressVeiw_zero.mod.Mobile = @"18210264050";
        addressVeiw_zero.mod.Address = @"北京市东城区朝阳门内大街288号凯德华玺大厦901";
        addressVeiw_zero.mod.Name = @"北京墨品科技股份有限公司";
        [addressVeiw_zero setNeedsLayout];
    }
   
    
    /*作品信息*/
    OrderRequestModel *requestMod = [[OrderRequestModel alloc]init];
    requestMod.size = _mod.Size;
    requestMod.wordType = _mod.Wordtype;
    requestMod.Content = _mod.WordNum;
    requestMod.IsTiKuan = _mod.ISInscribe;
    requestMod.TKContent = _mod.ISInscribe;
    requestMod.zouQi = _mod.CreateCycle;
    requestMod.showType = _mod.ShowType;
    requestMod.paperType = _mod.Material;
    requestMod.PhotoURL = _mod.PicPath;
    requestMod.ZhBType = _mod.ZhBStyle;
    workInfo_first.mod = requestMod ;
    
    
    [workInfo_first setNeedsLayout];
    [orderInfoView_second setNeedsLayout];
    [orderPriceView_third setNeedsLayout];
    [zhuanBiaoWuliuView_third setNeedsLayout];
    [faPiaoInfoView_third setNeedsLayout];
    [totalPayView_third setNeedsLayout];
    
    /*留言和数量*/
    orderInfoView_second.chooseNumber = _mod.OrderNum;
    orderInfoView_second.enableCheck = _mod.Remark.length?YES:NO;
     orderInfoView_second.liuYanStr = _mod.Remark;
    [orderInfoView_second updateUI];
   
   
    
    /*选劵的信息*/
    orderPriceView_third.priceStr = [NSString stringWithFormat:@"%@",_mod.Price.length?_mod.Price:@"0.00"];
    orderPriceView_third.usedSjJuan =  _mod.SJCoupon.length?_mod.SJCoupon:@"0";
    orderPriceView_third.usedMpJuan =  _mod.MPCoupon.length?_mod.MPCoupon:@"0";
    orderPriceView_third.usedTotalAmount =  _mod.Discount.length?_mod.Discount:@"0";
    
    [orderPriceView_third setFinishedChooseDisplayView];

    
    zhuanBiaoWuliuView_third.wuliuPrice = _mod.Deliver.length?_mod.Deliver:@"快递费0.00元"; //物流价格
    zhuanBiaoWuliuView_third.zhuanBiaoPrice = _mod.Packprice.length?_mod.Packprice:@"0.00元";  //装裱价格
    [zhuanBiaoWuliuView_third _initUI];
    
    /*实付*/
    totalPayView_third.priceStr =_mod.Amount;
    
    /*发票信息*/
    if(_mod.Receiptcontent.length)
    {
        faPiaoInfoView_third.faPiaoContent = _mod.Receiptcontent;
        [faPiaoInfoView_third _initUI];
    }else{
    
        [faPiaoInfoView_third removeFromSuperview];
        faPiaoInfoView_third = nil;
        _bgScrollView.contentSize = CGSizeMake(0, _bgScrollView.contentSize.height-50);
    }
    
    

}

@end
