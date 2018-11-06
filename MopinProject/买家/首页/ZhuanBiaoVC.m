//
//  ZhuanBiaoVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ZhuanBiaoVC.h"
#import "UIRadioControl.h"
#import "KuangBiaoChooseView.h"
#import "XHDHelper.h"
#import "ZhuanBiaoTypeMod.h"
#import "UIKit+AFNetworking.h"

@interface ZhuanBiaoVC ()<UIScrollViewDelegate>
{
    UIScrollView *_baseScollerView;  //背景滚动视图
    
    NSMutableArray *dataArr;
    
    UIRadioControl *mainRadio; //段头选择视图
    UIView  *firstView;
    KuangBiaoChooseView *FirstContentView;
    
    UIView *secondView;
    KuangBiaoChooseView *SecondContentView;
    
    UIView *thirdView;
    
    UIButton *commitBnt_1; //提交按钮1
    UIButton *commitBnt_2;
    
    __block NSString *selectTypeID; //装裱类型ID
    __block NSString *selectStyleID; //选择装裱的样式ID
    __block NSString *zhuBiaoPrice; //装裱价格
    __block NSString *zhuBiaoSize; //装裱尺寸
    __block NSString *ZhBStyleName; //装裱名字
    __block NSString *ZhBStylePic; //装裱样式图片
   
}

@end

@implementation ZhuanBiaoVC
- (instancetype)initWithArtID:(NSString*)artID AndModel:(ZhuanBiaoTypeMod*)ZbTypeMod
{
   if(self = [super init])
   {
       _ArtID = artID;
       selectTypeID = ZbTypeMod.ZhBTypeID;
       selectStyleID = ZbTypeMod.ZhBStyle;
       zhuBiaoPrice = ZbTypeMod.ZhBPrice;
       zhuBiaoSize = ZbTypeMod.ZhBSize;
       ZhBStyleName = ZbTypeMod.ZhBStyleName;
       ZhBStylePic = ZbTypeMod.ZhBStylePic;
       
       dataArr = [[NSMutableArray alloc]init];
       [self requestDateOfZhuanBiaoType];
   }
    return self;
}

/*返回*/
- (void)backBtnClick
{
    [self setEditing:YES animated:YES];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确定放弃选择吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"装裱方式";
   [self setNavBackBtnWithTitle:@"取消"];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createHeaderView];
    [self createBaseScrollerView];
    [self createFirstView];
    [self createSecondView];
    [self createThirdView];
    
}


#pragma mark -- 创建滚动视图
- (void)createBaseScrollerView
{
    _baseScollerView = [[UIScrollView alloc]initWithFrame:mRect(0, mainRadio.bottom ,kkDeviceWidth, kkDeviceHeight-mainRadio.height-63)];
    _baseScollerView.showsHorizontalScrollIndicator = NO;
    _baseScollerView.showsVerticalScrollIndicator = NO;
    _baseScollerView.contentSize = CGSizeMake(kkDeviceWidth*3, 0);
    _baseScollerView.delegate = self;
    _baseScollerView.pagingEnabled = YES;
    [self.view addSubview:_baseScollerView];
    if(selectTypeID.length)
    {
        mainRadio.selectedIndex = selectTypeID.integerValue -1;
        [UIView animateWithDuration:0.3 animations:^{
            _baseScollerView.contentOffset = CGPointMake(kkDeviceWidth*mainRadio.selectedIndex, 0);
        }];
        
    }
}
#pragma mark -- 段头  1-推荐内容 2-自选内容 3-自拟内容
- (void)createHeaderView
{
    NSArray *items = @[@"框裱",@"轴裱",@"不装裱"];
    mainRadio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,-0.5,kkDeviceWidth,35.5) items:items];
    mainRadio.selectedIndex = 0;
    [mainRadio setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
    [mainRadio setTitleColor:MainFontColor forState:UIControlStateNormal];
    mainRadio.Font=UIFONT(14);
    mainRadio.enableSwipe  = YES;
    mainRadio.tag = 987;
    [mainRadio addTarget:self action:@selector(radioValueChanged:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainRadio];
    
}
- (void)radioValueChanged:(UIRadioControl*)radio
{
    if(radio.tag == 987)
    {
        /*点击，传入一个数组到，改变*/
        switch (radio.selectedIndex) {
            case 0:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    _baseScollerView.contentOffset = CGPointMake(0, 0);
                }];
                if(dataArr.count>0)
                {
                    if(FirstContentView.dataDic==nil)
                    {
                      [FirstContentView setDataDic:dataArr[0]];
                    }
                  
                }
                
                
            }
                break;
            case 1:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    _baseScollerView.contentOffset = CGPointMake(kkDeviceWidth, 0);
                }];
                if(dataArr.count>1)
                {
                    if(SecondContentView.dataDic==nil)
                    {
                       [SecondContentView setDataDic:dataArr[1]];
                    }
                }
                
            }
                break;
            case 2:
            {
                [UIView animateWithDuration:0.3 animations:^{
                    _baseScollerView.contentOffset = CGPointMake(kkDeviceWidth*2, 0);
                }];
            }
                break;
                
            default:
                break;
        }
        
    }
}
#pragma mark -- 第一段 框表
- (void)createFirstView
{
    FirstContentView = [[KuangBiaoChooseView alloc]initWithFrame:mRect(0, 0, _baseScollerView.width, kkDeviceHeight-64) StyleID:selectStyleID StyleName:ZhBStyleName];
    
    
    FirstContentView.finishChoose = ^(ZhuanBiaoTypeMod*mod)
    {
        selectStyleID = mod.ZhBStyle;
        zhuBiaoPrice = mod.ZhBPrice;
        zhuBiaoSize = mod.ZhBSize;
        ZhBStyleName = mod.ZhBStyleName;
        ZhBStylePic = mod.ZhBStylePic;
    };
    
    [_baseScollerView addSubview:FirstContentView];
    
    /*提交按钮*/
    commitBnt_1 = [XHDHelper getRedGeneralButtonWithFrame:mRect(0,_baseScollerView.height-kkSureButtonH, kkDeviceWidth, kkSureButtonH) AndTitleString:@"确认"];
    commitBnt_1.titleLabel.font = UIFONT_Tilte(16);
    [commitBnt_1 addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    commitBnt_1.tag = 550;
    commitBnt_1.hidden = YES;
    
    [_baseScollerView addSubview:commitBnt_1];
    
}
#pragma mark -- 第二段 轴裱
- (void)createSecondView
{
    SecondContentView = [[KuangBiaoChooseView alloc]initWithFrame:mRect(_baseScollerView.width, 0, _baseScollerView.width, kkDeviceHeight-64) StyleID:selectStyleID StyleName:ZhBStyleName];
    
    SecondContentView.finishChoose = ^(ZhuanBiaoTypeMod*mod)
    {
        selectStyleID = mod.ZhBStyle;
        zhuBiaoPrice = mod.ZhBPrice;
        zhuBiaoSize = mod.ZhBSize;
        ZhBStyleName = mod.ZhBStyleName;
        ZhBStylePic = mod.ZhBStylePic;
    };
    [_baseScollerView addSubview:SecondContentView];
    
    /*提交按钮*/
    commitBnt_2 = [XHDHelper getRedGeneralButtonWithFrame:mRect(kkDeviceWidth,_baseScollerView.height-kkSureButtonH, kkDeviceWidth, kkSureButtonH) AndTitleString:@"确认"];
    commitBnt_2.titleLabel.font = UIFONT_Tilte(16);
    [commitBnt_2 addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    commitBnt_2.tag = 551;
    commitBnt_2.hidden = YES;
    [_baseScollerView addSubview:commitBnt_2];

    
}
#pragma mark -- 第三段 不装表
- (void)createThirdView
{
   thirdView = [[UIView alloc]initWithFrame:mRect(kkDeviceWidth*2, 0,kkDeviceWidth, 215)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [_baseScollerView addSubview:thirdView];
    
    
    /*图片>从上一个控制器传过来*/
    UIImageView *displayImageView = [[UIImageView alloc]initWithFrame:mRect(25,25, thirdView.width-50, 120)];
    [displayImageView  setImageWithURL:[NSURL URLWithString:@""/*_ArtPic*/] placeholderImage: mImageByName(@"pic_10")];
    displayImageView.tag = 1111;
    [thirdView addSubview:displayImageView];
    
    //所需装裱费
    UILabel *zhuanBiaoFee = [XHDHelper createLabelWithFrame:mRect(25, displayImageView.bottom+15, thirdView.width-50, 50) andText:@"所需装裱费:￥200" andFont:UIFONT(15) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"所需装裱费:￥%@",@(0)]];
    [str addAttributes:@{NSForegroundColorAttributeName:THEMECOLOR_1} range:NSMakeRange(6, str.length-6)];
    zhuanBiaoFee.attributedText = str;
    [thirdView addSubview:zhuanBiaoFee];
    
    /*提交按钮*/
    UIButton *commitBnt_3 = [XHDHelper getRedGeneralButtonWithFrame:mRect(kkDeviceWidth*2,_baseScollerView.height-kkSureButtonH, kkDeviceWidth, kkSureButtonH) AndTitleString:@"确认"];
    commitBnt_3.titleLabel.font = UIFONT_Tilte(16);
    [commitBnt_3 addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    commitBnt_3.tag = 552;
    [_baseScollerView addSubview:commitBnt_3];
    
}

/*确定按钮动作*/
- (void)commitAction:(UIButton*)sender
{
   
    if(mainRadio.selectedIndex == 0)
    {
       selectTypeID = @"1";
    }
    else if(mainRadio.selectedIndex == 1)
    {
      selectTypeID = @"2";
    }
    else if(mainRadio.selectedIndex == 2)
    {
       selectTypeID = @"3";
        selectStyleID = @"";
        zhuBiaoSize= @"";
        zhuBiaoPrice = @"";
        ZhBStylePic = @"";
        ZhBStyleName = @"";
    }
    
    if(([selectTypeID isEqualToString:@"1"]||[selectTypeID isEqualToString:@"2"])&& selectStyleID.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"您还未选择装裱样式！"];
        return;
    }
    
    if([_delegate respondsToSelector:@selector(finishZhuanBiaoChooseWithZhuanBiaoModel:)])
    {
        /*匹配Mod,将选中的装裱类型mod传回去*/
        ZhuanBiaoTypeMod *mod = [[ZhuanBiaoTypeMod alloc]init];
        
        mod.ZhBTypeID = selectTypeID;
        mod.ZhBStyle  = selectStyleID;
        mod.ZhBSize  =  zhuBiaoSize;
        mod.ZhBPrice = zhuBiaoPrice;
        mod.ZhBStylePic = ZhBStylePic;
        mod.ZhBStyleName = ZhBStyleName;
        
        [_delegate finishZhuanBiaoChooseWithZhuanBiaoModel:mod];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    if(x<_baseScollerView.width)
    {
        mainRadio.selectedIndex = 0;
    }
    else if(x<_baseScollerView.width*2)
    {
        mainRadio.selectedIndex = 1;
    }
    else if(x<_baseScollerView.width*3)
    {
        mainRadio.selectedIndex = 2;
    }
}

/*请求装裱内容*/
/*
 "data": [
 {
 "ZhBType": "1",
 "ZhBStyleData": [
 {
 "ZhBStyle": "1",
 "ZhBStyleName": "样式一",
 "ZhBStylePic": "http://www.baidu.com/1.jpg",
 "ZhBSize": "1000m*3000m",
 "ZhBPrice": "1000"
 },
 {
 "ZhBStyle": "2",
 "ZhBStyleName": "样式二",
 "ZhBStylePic": "http://www.baidu.com/2.jpg",
 "ZhBSize": "1000m*3000m",
 "ZhBPrice": "2000"
 }
 ]
 },
 {
 "ZhBType": "2",
 "ZhBStyleData": [
 {
 "ZhBStyle": "3",
 "ZhBStyleName": "样式一",
 "ZhBStylePic": "http://www.baidu.com/1.jpg",
 "ZhBSize": "1000m*3000m",
 "ZhBPrice": "1000"
 },
 {
 "ZhBStyle": "4",
 "ZhBStyleName": "样式二",
 "ZhBStylePic": "http://www.baidu.com/2.jpg",
 "ZhBSize": "1000m*3000m",
 "ZhBPrice": "2000"
 }
 ]
 }
 ]
 */
- (void)requestDateOfZhuanBiaoType
{
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetZhBInfo" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_ArtID forKey:@"ArtID"];
    
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
                //返回的是一个数组，，数组里面是字典
                if([dic[@"ZhBType"]isEqualToString:@"1"])
                {
                    [FirstContentView setDataDic:dic];
                    [dataArr insertObject:dic atIndex:0];
                   
                    if(((NSArray*)dic[@"ZhBStyleData"]).count>0)
                    {
                        commitBnt_1.hidden = NO;
                    }
                }
                else if([dic[@"ZhBType"]isEqualToString:@"2"])
                {
                    [SecondContentView setDataDic:dic];
                    [dataArr insertObject:dic atIndex:1];
                    if(((NSArray*)dic[@"ZhBStyleData"]).count>0)
                    {
                       commitBnt_2.hidden = NO;
                    }
                    
                }
                
            }
            
        }
        /*如果装裱样式数组无记录，就默认不装裱*/
        if(dataArr.count==0)
        {
            mainRadio.selectedIndex = 2;
            
        }
        _baseScollerView.contentOffset = CGPointMake(kkDeviceWidth*mainRadio.selectedIndex, 0);
        
        
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
