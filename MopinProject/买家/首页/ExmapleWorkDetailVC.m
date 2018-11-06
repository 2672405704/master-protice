//
//  ExmapleWorkDetailVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ExmapleWorkDetailVC.h"
#import "XHDADBanner.h"
#import "XHDHelper.h"
#import "CustomPriceView.h"
#import "WorkDetailModel.h"
#import "CommentListMod.h"
#import "FirstSectionView.h"
#import "SecondSectionView.h"
#import "ThirdSectionView.h"
#import "FouthSectionView.h"
#import "FifthSectionView.h"
#import "SixthSectionView.h"
#import "PenmanDetailViewController.h"

#import "shareTools.h"
#import "CustomWorkListVC.h"
#import "LoginViewController.h"
#import "ImgShowViewController.h"


@interface ExmapleWorkDetailVC ()<FirstSectionDelegate,sixthSectionViewDelegate>
{
    XHDADBanner *banner;
    CustomPriceView *priceLab; //价格Lab
    WorkDetailModel *DetailMod;
    UIScrollView *bgScrollView;
    
    NSInteger stockNum; //库存数量
    NSInteger NoncommercialStockNum; //公益库存量
    
    //段视图背景
    FirstSectionView *FristBgView;
    SecondSectionView *SecondBgView;
    ThirdSectionView *ThirdBgView;
    FouthSectionView *FouthBgView;
    FifthSectionView *FiftyBgView;
    SixthSectionView *SixthBgView;
    
    BOOL isChange;  //改变赞和收藏 刷新书家主页
}
@property(nonatomic,strong)NSString *PMID;//书家ID
@property(nonatomic,strong)NSString *artID;//作品ID
@property(nonatomic,strong)NSString *artPrice;//作品价格
@end

@implementation ExmapleWorkDetailVC
-(void)dealloc
{
    [mNotificationCenter removeObserver:self name:@"changeScrollViewHeight" object:nil];
     [mNotificationCenter removeObserver:self name:@"checkZoomImage" object:nil];

}
- (instancetype)initWithArtID:(NSString*)artID
                  AndArtPrice:(NSString*)artPrice
                         PMID:(NSString*)PMID
{
    self = [super init];
    if (self) {
        _artID =artID;
        _artPrice = artPrice;
        _PMID = PMID;
        DetailMod = [[WorkDetailModel alloc]init];
        
        [mNotificationCenter addObserver:self selector:@selector(changeScrollViewH:) name:@"changeScrollViewHeight" object:nil];
        [mNotificationCenter addObserver:self selector:@selector(checkZoomImage:) name:@"checkZoomImage" object:nil];
      [self requestData];
    }
    return self;
}
/*查看图片*/
-(void)checkZoomImage:(NSNotification*)noti
{
    NSDictionary *dic = noti.userInfo;
    NSInteger index = (NSInteger)dic[@"index"];
    ImgShowViewController *showVC = [[ImgShowViewController alloc]initWithSourceData: dic[@"imageArr"] withIndex:index];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:showVC];
    [self.navigationController presentViewController:navi animated:YES completion:nil];

}
- (void)changeScrollViewH:(NSNotification*)noti
{
    NSDictionary  *dic = noti.userInfo;
    CGFloat height =  ((NSString*)dic[@"changHeight"]).floatValue;
    {
        SixthBgView.height += height;
        bgScrollView.contentSize = CGSizeMake(0, bgScrollView.contentSize.height+height);
    }

}
- (void)backBtnClick
{
    if(isChange){
        if (_refreshPenmanDetail) {
            
             self.refreshPenmanDetail();
        }
       
    }
    [super backBtnClick];
}
#pragma mark -- 背景滚动视图
- (void)CreateBackScrollView
{
    bgScrollView = [[UIScrollView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, kkDeviceHeight-64-45)];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.contentSize = CGSizeMake(0, 1150);
    [self.view addSubview:bgScrollView];

}
#pragma mark -- 创建开始定制按钮
- (void)createBeginButton
{
    UIButton *beginBnt = [XHDHelper getRedGeneralButtonWithFrame:mRect(0, kkDeviceHeight-64-45, kkDeviceWidth,kkSureButtonH) AndTitleString:@"开始定制"];
    [beginBnt addTarget:self action:@selector(gotoBeginToDo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginBnt];
    
    /*调用查看样品库存的接口*/
    [self getArtStockNum];

}
/*开始定制作品*/
- (void)gotoBeginToDo:(UIButton*)sender
{
    /*0.会否登陆了*/
    if([PersonalInfoSingleModel shareInstance].UserID.length==0||[[PersonalInfoSingleModel shareInstance].UserID isEqualToString:@"0"])
    {
        [self gotoLogin];
    }
    
    /*1.判断是否是定制了自己的做品*/
    if([[PersonalInfoSingleModel shareInstance].UserID isEqualToString:DetailMod.PMID])
    {
        [SVProgressHUD showErrorWithStatus:@"尊敬的书家,请勿定制自己的作品，谢谢合作！"];
        return;
    }
    
    /*2.判断可定制数是否大于0*/
    //是否开启了公益
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState]isEqualToString:@"1"])
    {
        //是公益作品
        if([DetailMod.IsPublicGoodSample isEqualToString:@"1"])
        {
            //判断是否具有资格
            if([[PersonalInfoSingleModel shareInstance].IsFreeQualify isEqualToString:@"1"])
            {
                
                //判断是否两个库存都小于0，是 return
                if(stockNum<=0&&NoncommercialStockNum<=0)
                {
                    [SVProgressHUD showErrorWithStatus:@"书家可接受定制数已满!"];
                    return;
                }
            
            }else{  //没有资格，就只判断库存量
            
                 if(stockNum<=0)
                 {
                     [SVProgressHUD showErrorWithStatus:@"书家可接受定制数已满!"];
                     return;
                 
                 }
            }
        
        }else{  //不是公益作品
        
            if(stockNum<=0){
                
                [SVProgressHUD showErrorWithStatus:@"书家可接受定制数已满!"];
                return;
            }
        
        }
        
    }else{ //没开启公益就直接判断库存量
        
        if(stockNum<=0){
            
            [SVProgressHUD showErrorWithStatus:@"书家可接受定制数已满!"];
            return;
        }
    }
    
    
    
    CustomWorkListVC *cusWork = [[CustomWorkListVC alloc]initWithArtID:_artID WorkDetailMod:DetailMod];
    [self.navigationController pushViewController:cusWork animated:YES];

}
#pragma mark -- 视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"定制样品";
    self.navigationController.navigationBarHidden=NO;
    [self setNavBackBtnWithType:1];
    [self setRightNavImageIconWithFrame:CGSizeMake(22, 22) andImageStr:@"share_penman.png"];
    [SVProgressHUD dismiss];
}
/*右键，分享*/
- (void)rightNavBtnClick
{
    ShareMopinModel *shareModel=[[ShareMopinModel alloc]init];
    shareModel.desc=@"墨品定制";
    shareModel.type=ShareMopinSampleType;
    shareModel.title=DetailMod.ArtName;
    shareModel.shareUrl=[NSString stringWithFormat:@"%@%@",SHARE_SAMPLE,_artID];
    [ShareTools shareAllButtonClickHandler:shareModel andSucess:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CreateBackScrollView];
    [self createBeginButton];
    [self creatBanner];
    [self createArtMainTipView];
    [self createCommentListView];
    [self createActivityView];
    [self createFitScreenView];
    [self createArtMainIntroduceView];
    [self createPenManIntroduceView];
    
}

#pragma mark -- 广告版的设置
- (void)creatBanner
{
    /*广告版*/
    banner = [[XHDADBanner alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, 200)];
    banner.imageURLArr = nil;
    banner.pageControl.alpha = 0;
    banner.pageContorBg.alpha = 0;
    banner.delegate = self;
    [bgScrollView addSubview:banner];
    [XHDHelper addDivLineWithFrame:mRect(0, banner.height-0.4, banner.width, 0.4) SuperView:banner];
    
    //价格Label
    priceLab = [[CustomPriceView alloc]initWithFrame:mRect(0, banner.bottom-40, 70, 30) WithPrice:_artPrice.length?[NSString stringWithFormat:@"%ld",_artPrice.integerValue]: @"0.00"];
    [banner addSubview:priceLab];

}

#pragma mark -- 第一段 作品概要
- (void)createArtMainTipView
{
    FristBgView = [[FirstSectionView alloc]initWithFrame:mRect(0,banner.bottom, kkDeviceWidth, 330)];
    FristBgView.delegate = self;
    FristBgView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:FristBgView];
    
}

//TODO:刷新书家
- (void)backToRefreshPenmanDetail
{
    isChange=YES;
}

/*去登陆*/
- (void)gotoLogin
{
        LoginViewController *login = [[LoginViewController alloc]init];
        login.formVCTag = 1;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark -- 第二段 评论
- (void)createCommentListView
{
    CGFloat height = 90;
    SecondBgView = [[SecondSectionView alloc]initWithFrame:mRect(0,FristBgView.bottom, kkDeviceWidth, height)];
    /*填充参数*/
    SecondBgView.delegate = self;
    SecondBgView.ArtID = _artID;
    SecondBgView.EvaluationNum = @"0";
    [bgScrollView addSubview:SecondBgView];
    [SecondBgView setBackgroundColor:[UIColor clearColor]];
    bgScrollView.contentSize = CGSizeMake(0, bgScrollView.contentSize.height+SecondBgView.height);

}

#pragma mark -- 第三段 促销活动的View
- (void)createActivityView
{
    ThirdBgView = [[ThirdSectionView alloc]initWithFrame:mRect(0, SecondBgView.bottom, kkDeviceWidth, 200)];
    [bgScrollView addSubview:ThirdBgView];
    ThirdBgView.backgroundColor = [UIColor whiteColor];
    ThirdBgView.ReturnCoupon = DetailMod.ReturnCoupon;//返劵
    ThirdBgView.Promotional = DetailMod.Promotional;//促销活动
    bgScrollView.contentSize = CGSizeMake(0, bgScrollView.contentSize.height+ThirdBgView.height);
    
}

#pragma mark -- 第四段 适用场景
- (void)createFitScreenView
{
    FouthBgView = [[FouthSectionView alloc]initWithFrame:mRect(0, ThirdBgView.bottom+10, kkDeviceWidth, 120) PlaceStr:DetailMod.Place];
    [bgScrollView addSubview:FouthBgView];
    FouthBgView.backgroundColor = [UIColor clearColor];
    bgScrollView.contentSize = CGSizeMake(0, bgScrollView.contentSize.height+FouthBgView.height);
  
}

#pragma mark -- 第五段 定制要约
- (void)createArtMainIntroduceView
{
    FiftyBgView = [[FifthSectionView alloc]initWithFrame:mRect(0, FouthBgView.bottom,kkDeviceWidth,360)];
    [bgScrollView addSubview:FiftyBgView];
    FiftyBgView.backgroundColor = [UIColor whiteColor];
}

#pragma mark -- 第六段 书家介绍
- (void)createPenManIntroduceView
{
    SixthBgView = [[SixthSectionView alloc]initWithFrame:mRect(0, FiftyBgView.bottom, kkDeviceWidth, 300)];
    SixthBgView.delegate = self;
    [bgScrollView addSubview:SixthBgView];
}


#pragma mark -- 网络请求
/*样品库存*/
- (void)getArtStockNum
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetPMStockNum" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_PMID.length?_PMID:@"0" forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonData=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000)
        {
            stockNum =  ((NSString*)jsonObject[@"data"][@"StockNum"]).integerValue;
            NoncommercialStockNum  = ((NSString*)jsonObject[@"data"][@"NoncommercialStockNum"]).integerValue;
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];


}
/*详情请求*/
- (void)requestData
{
    [SVProgressHUD showWithStatus:@"正在努力加载中..."];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetSampleDetail" forKey:@"Method"];
    [parameterDic setValue:@"2.0" forKey:@"Infversion"];
    [parameterDic setValue:_artID forKey:@"ArtID"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID.length?[PersonalInfoSingleModel shareInstance].UserID:@"0" forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
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
               //填充数据
                [DetailMod setValuesForKeysWithDictionary:dic];
                
            }
            [self FillDataAndRefreshUI];
            
        }
       
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
#pragma mark -- 填充数据刷新UI
- (void)FillDataAndRefreshUI
{

     /*广告版*/
    NSMutableArray *imageArr = [NSMutableArray new];
    if([DetailMod.Image isKindOfClass:[NSArray class]])
    {
        for(NSDictionary *dic in DetailMod.Image)
        {
            NSString *urlStr = dic[@"SamplePic"];
            [imageArr addObject:urlStr];
        }
    }
    banner.imageURLArr = imageArr;
    priceLab.price = [NSString stringWithFormat:@"%ld",DetailMod.Price.length?DetailMod.Price.integerValue:0];
    
    /*是否添加公益样品的标识*/
    if([[[PublicWelfareManager shareInstance]getPublicWelfareState] isEqualToString:@"1"])
    {
        if(DetailMod.IsPublicGoodSample.length){ //有这个标识才去判断
        
            if([DetailMod.IsPublicGoodSample isEqualToString:@"1"])
            {  //是公益样品才去添加
                
                UIImageView *publicIcon = [[UIImageView alloc]initWithFrame:mRect(0, 0, 60, 60)];
                publicIcon.image = [UIImage imageNamed:@"red_sign"];
                 [banner addSubview:publicIcon];
            }
            if([DetailMod.IsPublicGoodSample isEqualToString:@"2"])
            {
                UIImageView *publicIcon = [[UIImageView alloc]initWithFrame:mRect(0, 0, 60, 60)];
                publicIcon.image = [UIImage imageNamed:@"gary_sign"];
                 [banner addSubview:publicIcon];
            }
        }
    }
    
    /*第一段*/
    FristBgView.TitleStr = DetailMod.ArtName; //标题
    FristBgView.AttributeStr = [NSString stringWithFormat:@"%@/%@/%@",DetailMod.ShowType,DetailMod.WordType,DetailMod.Size];//属性
    FristBgView.EnableJuanStr = [NSString stringWithFormat:@"可用卷：%@%%",DetailMod.CouponsRatio];//可用劵
    FristBgView.MoPinJuanStr = [NSString stringWithFormat:@"墨品劵 %@%% （￥%@元）",DetailMod.MPCouponRatio,DetailMod.MPCouponAmount];//磨品劵
    FristBgView.ShujiaJuanStr= [NSString stringWithFormat:@"书家劵 %@%% （￥%@元）",DetailMod.SJCouponRatio,DetailMod.SJCouponAmount];//书家劵
    FristBgView.ArtIntroduceStr = DetailMod.Intro;//作品介绍
    FristBgView.favoriteNum = DetailMod.ZanNum;//点赞按钮
    FristBgView.collectionNum= DetailMod.CollectNum;//收藏按钮
    FristBgView.finishNum = DetailMod.BookedNum;//成交按钮
    FristBgView.ArtID = _artID;
    FristBgView.isZan = DetailMod.IsZan;  //是否赞了
    FristBgView.isCollection = DetailMod.IsCollect;//是否已收藏
    [FristBgView UpdateUI];
    
    
    /*第二段*/
    CGFloat  height = 90;
    if(DetailMod.Evaluation>0)
    {
        SecondBgView.frame = mRect(0,FristBgView.bottom, kkDeviceWidth, height);
        NSMutableArray *commentArr = [[NSMutableArray alloc]init];
        
        for(NSDictionary *dic in DetailMod.Evaluation)
        {
            CommentListMod *mod  = [[CommentListMod alloc]init];
            mod.Content = dic[@"EContent"];
            mod.EID = dic[@"EID"];
            mod.Nickname = dic[@"ENickName"];
            mod.PhotoPath = dic[@"EPhoto"];
            mod.ReContent = dic[@"EReContent"];
            mod.ImageData = dic[@"ImageData"];
            [commentArr addObject:mod];
        }
        
        SecondBgView.EvaluationNum = DetailMod.EvaluationNum;
        SecondBgView.ArtID = _artID;
        SecondBgView.CommentArr = commentArr;
        [SecondBgView tableViewReloadDate];
    }
    height = [SecondBgView getSecondHeight];
    SecondBgView.height = height;
    
    
        /*第三端*/
        if(DetailMod.Promotional.length>0)
        {
            
          ThirdBgView.height = 235;
        
         }else{
        
          ThirdBgView.height = 145;
        }
        ThirdBgView.top = SecondBgView.bottom;
        ThirdBgView.ReturnCoupon = DetailMod.ReturnCoupon;//返劵
        ThirdBgView.Promotional = DetailMod.Promotional;//促销活动
        [ThirdBgView updateUI];

        /*第四端*/
        FouthBgView.top = ThirdBgView.bottom;
        FouthBgView.Place = DetailMod.Place;
        [FouthBgView initDisplayView];
    
        /*第5端*/
        FiftyBgView.top = FouthBgView.bottom;
        /*填充参数*/
        FiftyBgView.ShowType = DetailMod.ShowType;
        FiftyBgView.WordType = DetailMod.WordType;
        FiftyBgView.WordNum = DetailMod.WordNum;
        FiftyBgView.Size = DetailMod.Size;
        FiftyBgView.ISInscribe = DetailMod.ISInscribe;
        FiftyBgView.Material = DetailMod.Material;
        FiftyBgView.CreateCycle = DetailMod.CreateCycle;
        [FiftyBgView UpdateUI];
    
        /*第6端*/
        SixthBgView.top = FiftyBgView.bottom;
    
        /*填充参数*/
        SixthBgView.PenmanName = DetailMod.PenmanName;
        SixthBgView.PenmanType = DetailMod.PenmanType;
        SixthBgView.IsBooked   = DetailMod.IsBooked;
        SixthBgView.Signature  = DetailMod.Signature;
        SixthBgView.PenmanID = DetailMod.PMID;
        SixthBgView.Photo  =  DetailMod.Photo;
        SixthBgView.Trend = DetailMod.Trend;
        SixthBgView.NPrice = DetailMod.NPrice;
        SixthBgView.AveragePrice = DetailMod.AveragePrice;
        [SixthBgView UpdateUI];
        
        //背景高度
        bgScrollView.contentSize = CGSizeMake(0,banner.height + FristBgView.height+SecondBgView.height + ThirdBgView.height + FouthBgView.height + FiftyBgView.height + SixthBgView.height + 20);

        [SVProgressHUD dismiss];
    
}

#pragma mark -- 查看书家
-(void)checkPenManDetailWithPenManID:(NSString*)penManID
{
    if(DetailMod.PMID.length>0)
    {
        PenmanDetailViewController *penMandetail = [[PenmanDetailViewController alloc]initWithNibName:@"PenmanDetailViewController" bundle:[NSBundle mainBundle]];
        penMandetail.penmanID = DetailMod.PMID;
        [self.navigationController pushViewController:penMandetail animated:YES];
       
    }

}


- (void)didReceiveMemoryWarning
 {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
