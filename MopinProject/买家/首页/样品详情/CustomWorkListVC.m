//
//  CustomWorkListVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CustomWorkListVC.h"
#import "CustomWorkVC.h" //定制样品
#import "IfSignedVC.h"
#import "ZhuanBiaoVC.h"
#import "XHDHelper.h"
#import "ComfireOrderVC.h"  //确认订单
#import "WorkDetailModel.h"

#import "OrderRequestModel.h"  //下单模型
#import "LoginViewController.h"
#import "ZhuanBiaoTypeMod.h"

#pragma mark -- 选择项视图
@interface ChooseItemView:UIControl
@property(nonatomic,strong)UILabel *contentLabel;//内容显示的界面

- (instancetype)initWithFrame:(CGRect)frame
                  TitleString:(NSString*)titleStr
                 placeHoldStr:(NSString*)placeHoldStr;

@end

@implementation ChooseItemView
{
    NSString *_titleStr; //标题
    NSString *_placeStr; //默认选项
}
- (instancetype)initWithFrame:(CGRect)frame
                  TitleString:(NSString*)titleStr
                 placeHoldStr:(NSString*)placeHoldStr
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleStr = titleStr;
        _placeStr = placeHoldStr;
        self.backgroundColor = [UIColor whiteColor];
        [self _initUI];
    }
    return self;
}
- (void)_initUI
{
    UILabel *titleLab = [XHDHelper createLabelWithFrame:mRect(25, 5, 80, 30) andText:_titleStr andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:titleLab];
    
    //提示内容
    _contentLabel = [XHDHelper createLabelWithFrame:mRect(titleLab.right+10, 5, 150, 30) andText:_placeStr andFont:UIFONT(14) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.right = self.width-40;
    [self addSubview:_contentLabel];
    
    //右键图标
    UIImageView *rightRow = [XHDHelper createImageViewWithFrame:mRect(0, 12.5, 10, 15) AndImageName:@"chevron_right" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:nil];
    rightRow.right = self.width-25;
    [self addSubview:rightRow];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}
-(void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.5f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR_1.CGColor);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,self.frame.origin.x, self.frame.size.height );
    CGContextAddLineToPoint(context,self.frame.size.width, self.frame.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);

}

@end

#pragma mark -- 主控制器
@interface CustomWorkListVC ()<CustomWorkContentDelegate,CustomWorkIsTikuanDelegate,FinishZhuanBiaoChooseDelegate>

@end


@implementation CustomWorkListVC
{
    OrderRequestModel *orderMod;
    CustomWorkVC * cusWorkVC;
    ZhuanBiaoTypeMod *ZbMod;  //装裱样式mod，要传入装裱选择里面的
    NSString* oldSize;  //原来的尺寸
    
}
- (id)initWithArtID:(NSString*)artID
      WorkDetailMod:(WorkDetailModel*)detailMod
{
    self = [super init];
    if (self)
    {
        _ArtID = artID;
        _workDetailMod = detailMod;
    
      [self requestDataForWorkSampleDetail];
      orderMod =  [[OrderRequestModel alloc]init];
      orderMod.ArtID = _ArtID;
    }
    return self;
    
}

#pragma mark -- 视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"墨品定制";
    [self setNavBackBtnWithType:1];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createThreeItem];
    [self createSubmitButton];
}

#pragma mark -- 创建Item
- (void)createThreeItem
{
    NSArray *titArr = @[@"内容",@"题款",@"装裱"];
    NSArray *placeArr = @[@"点击选择定制内容",@"点击编辑题款内容",@"点击选择装裱方式"];
    for(NSInteger i = 0;i<3;i++)
    {
        ChooseItemView *view = [[ChooseItemView alloc]initWithFrame:mRect(0, 40*i, kkDeviceWidth, 40) TitleString:titArr[i] placeHoldStr:placeArr[i]];
        [self.view addSubview:view];
        view.tag = 1040+i;
        [view addTarget:self action:@selector(fillContentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
        

}
/*去填充数据*/
-(void)fillContentAction:(ChooseItemView*)sender
{

    if(sender.tag == 1040)//内容
    {
      cusWorkVC = [[CustomWorkVC alloc]initWithArtID:_ArtID AndChooseContent:orderMod.Content];
        cusWorkVC.delegate = self;
        cusWorkVC.minNum = _workDetailMod.WNMix.integerValue;
        cusWorkVC.maxNum = _workDetailMod.WNMax.integerValue;
        
    [self.navigationController pushViewController:cusWorkVC animated:YES];
       
    }
    else if(sender.tag==1041) //题款
    {
      IfSignedVC* next = [[IfSignedVC alloc]init];
        next.delegate = self;
        next.inputContent = orderMod.TKContent;
          [self.navigationController pushViewController:next animated:YES];
        
    }
    else if(sender.tag == 1042) //装裱
    {
    
       ZhuanBiaoVC* next = [[ZhuanBiaoVC alloc]initWithArtID:_ArtID AndModel:ZbMod];
        next.ArtPic = orderMod.PhotoURL;
        next.delegate = self;
        [self.navigationController pushViewController:next animated:YES];
    }
    
   
}


#pragma mark -- 确定按钮
- (void)createSubmitButton
{
    UIButton *commit = [XHDHelper getRedGeneralButtonWithFrame:mRect(0, kkDeviceHeight-64-45, kkDeviceWidth, kkSureButtonH) AndTitleString:@"确认"];
    commit.titleLabel.font = UIFONT_Tilte(16);
    [commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commit];

}
/*提交订单*/
- (void)commitAction:(UIButton*)sender
{
    /*传参 在这个界面处理的数据
     orderMod.ArtID
     orderMod.wordType
     orderMod.showType
     orderMod.size
     orderMod.paperType
     orderMod.zouQi
     orderMod.Amount
     orderMod.Content
     orderMod.IsTiKuan
     orderMod.TKContent
     orderMod.ZhBType
     orderMod.ZhBStyleID
     */
    
    /*判空*/
    if(orderMod.Content.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择定制内容"];
        return;
    }
    if(orderMod.IsTiKuan.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择是否题款"];
        return;
    }
    if([orderMod.IsTiKuan isEqualToString:@"1"])
    {
        if(orderMod.TKContent.length == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"请输入题款内容"];
            return;
        }
    }
    if(orderMod.ZhBType.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择装裱类型"];
        return;
    }
    if(orderMod.ZhBType.length)
    {
       //装裱类型默认为一
    }
    if(![[PersonalInfoSingleModel shareInstance]isLogin])
    {
        LoginViewController *login = [[LoginViewController alloc]init];
        login.formVCTag = 1;
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login];
        [self presentViewController:navi animated:YES completion:nil];
    }
    else
    {
        ComfireOrderVC *comfireVC  = [[ComfireOrderVC alloc]initWithMod:orderMod];
        
        [self.navigationController pushViewController:comfireVC animated:YES];
    }
   
  
}

#pragma mark -- 三个选择完毕后的Delegate
/*1.内容*/
- (void)finishedChooseWorkContent:(NSString*)customContent
{
    ChooseItemView *item_1 = (ChooseItemView*)[self.view viewWithTag:1040];
    item_1.contentLabel.text = [XHDHelper replaceString:NSMakeRange(4, customContent.length-8) withString:customContent BaseStringMinLentgh:8];
    orderMod.Content = customContent;
}

/*2.题款*/
- (void)finishedChooseWorkIsTikuan:(BOOL)isTiKuan
                        AndContent:(NSString*)customContent
{
    ChooseItemView *item_1 = (ChooseItemView*)[self.view viewWithTag:1041];
    item_1.contentLabel.text =  isTiKuan?customContent:@"(无)";
    orderMod.IsTiKuan = isTiKuan?@"1":@"0";
    orderMod.TKContent = customContent;

}

/*3.款裱类别*/
- (void)finishZhuanBiaoChooseWithZhuanBiaoModel:(ZhuanBiaoTypeMod *)zhMod
{
    /*将装裱样式的Mod保存，当重新进入装裱样式选择的时候代入*/
    ZbMod = zhMod;
    
    ChooseItemView *item_1 = (ChooseItemView*)[self.view viewWithTag:1042];
    NSString *str;
    if(zhMod.ZhBTypeID.integerValue == 1)
    {
        str  = @"框装";
    }
    if(zhMod.ZhBTypeID.integerValue == 2)
    {
       str  = @"轴装";
    }
    if(zhMod.ZhBTypeID.integerValue == 3)
    {
        str = @"不装裱";
    }
    
    item_1.contentLabel.text = [NSString stringWithFormat:@"%@ %@",str,zhMod.ZhBStyleName.length?zhMod.ZhBStyleName:@""];
    orderMod.ZhBType = zhMod.ZhBTypeID;
    orderMod.ZhBStyleID = zhMod.ZhBStyle;
    orderMod.ZhuanBiaoPrice = zhMod.ZhBPrice;
    
    /*如果是选择不装裱，则orderMod.size 为样品的尺寸*/
    orderMod.size = oldSize;//zhMod.ZhBTypeID.integerValue != 3?zhMod.ZhBSize:oldSize;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark -- 网络请求(请求样品详情，获取有用的数据)
- (void)requestDataForWorkSampleDetail
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetSampleDetail" forKey:@"Method"];
    [parameterDic setValue:@"2.0" forKey:@"Infversion"];
    [parameterDic setValue:_ArtID forKey:@"ArtID"];
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
                orderMod.wordType  =  dic[@"WordType"]; //字体类型
                orderMod.showType  =  dic[@"ShowType"]; //展示类型
                orderMod.size    =  dic[@"Size"];       //大小
                oldSize = dic[@"Size"];//大小
                orderMod.paperType = dic[@"Material"];  //纸张类别
                orderMod.zouQi =  dic[@"CreateCycle"];  //创作周期
                orderMod.Price = dic[@"Price"];   //样品价格
                orderMod.canUseMpJuan = dic[@"MPCouponRatio"];//可用墨品劵
                orderMod.canUseMpJuanAmount = dic[@"MPCouponAmount"];
                orderMod.canUseSjJuan = dic[@"SJCouponRatio"];//可用书家劵
                orderMod.canUseSjJuanAmount = dic[@"SJCouponAmount"];
                orderMod.Place = dic[@"Place"];//适用场所
                orderMod.PenManID = dic[@"PMID"]; //书家ID
                
                //是否可以题款
                orderMod.IsTiKuan = dic[@"ISInscribe"];
                orderMod.IsPublicGoodSample = dic[@"IsPublicGoodSample"];
                
                if([dic[@"Image"] isKindOfClass:[NSArray class]])
                {
                    if(((NSArray*)dic[@"Image"]).count>0)
                    {
                      orderMod.PhotoURL  = dic[@"Image"][0][@"SamplePic"];
                    }
                    
                }
                
            }
            [self updateDateUI];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}

-(void)updateDateUI
{
    //如果该样品不能题款，则第二行不可点击，且改变提示语
    if([orderMod.IsTiKuan isEqualToString:@"0"]||orderMod.IsTiKuan.length==0)
    {
       
        ChooseItemView *item = (ChooseItemView*)[self.view viewWithTag:1041];
        item.contentLabel.text  = @"不可题款";
        item.enabled = NO;
        orderMod.IsTiKuan = @"0";
        orderMod.TKContent = @"无";
        
    }
  
}

@end
