//
//  ExampleWorkVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/9.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ExampleWorkVC.h"
#import "XHDADBanner.h"
#import "UIRadioControl.h"
#import "XHDHelper.h"
#import "ExampleWorkCell.h"
#import "ExampleWorkModel.h"
#import "ExmapleWorkDetailVC.h"

#import "CustomCommentVC.h"

#define kPageSize  @"10"

static  NSString *identfyName =   @"ExampleWorkCell";

@interface ExampleWorkVC ()<UITableViewDelegate,UITableViewDataSource,ExampleWorkCellDelegate>
{
    NSInteger _selectIndex;
    NSInteger _markNum;//价格按钮表示
}

@property (nonatomic,strong)UITableView *workTable;//样品列表
@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation ExampleWorkVC

{
    UIView *radioView; //背景
    UIButton *totalBnt; //综合
    UIButton *favirateBnt;//人气
    UIButton *priceBnt; //价格
    UIView *bottomLine;//按钮底部的分割线
    
}

- (id)initWithModel:(GetSampleListModel*)model
{
    self = [super init];
    if (self)
    {
        _mod = model;
        _selectIndex = 1;
    }
    return self;

}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.navigationItem.title=@"定制样品";
        [self setNavBackBtnWithType:1];
    }
    return self;
}

#pragma mark -- view循环
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createCustomChooseButton];
    [self createTableView];
}


#pragma mark -- -- 广告版
- (void)createADBanner
{
    XHDADBanner *banner = [[XHDADBanner alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, 140)];
   // banner.array = @[@"banner",@"banner",@"banner"];
    [self.view addSubview:banner];

}

#pragma mark -- 添加自定制按钮
- (void)createCustomChooseButton
{
    
    radioView = [[UIView alloc]initWithFrame:mRect(-0.5, 0, kkDeviceWidth+1, 40)];
    radioView.backgroundColor = [UIColor whiteColor];
    radioView.layer.borderColor = DIVLINECOLOR_1.CGColor;
    radioView.layer.borderWidth = 0.3;
    [self.view addSubview:radioView];
    
    //综合按钮
    totalBnt = [XHDHelper createButton:mRect(0, 0, radioView.width/3.0-0.5, radioView.height) NomalTitle:@"综合" SelectedTitle:@"综合" NomalTitleColor:DIVLINECOLOR_2 SelectTitleColor:THEMECOLOR_1 NomalImage:nil SelectedImage:nil BoardLineWidth:0 target:self selector:@selector(buttonClickAction:)];
    totalBnt.tag = 666;
    totalBnt.selected = YES;
    totalBnt.titleLabel.font = UIFONT(15);
    [radioView addSubview:totalBnt];
    
    //分割线一
    UIView *divLine_1 = [[UIView alloc]initWithFrame:mRect(totalBnt.right, radioView.height/4.0, 0.5, radioView.height/2.0)];
    divLine_1.backgroundColor = DIVLINECOLOR_1;
    [radioView addSubview:divLine_1];
    
    //人气
    favirateBnt = [XHDHelper createButton:mRect(radioView.width/3.0+0.5, 0, radioView.width/3.0-0.5, radioView.height) NomalTitle:@"人气" SelectedTitle:@"人气" NomalTitleColor:DIVLINECOLOR_2 SelectTitleColor:THEMECOLOR_1 NomalImage:nil SelectedImage:nil BoardLineWidth:0 target:self selector:@selector(buttonClickAction:)];
    favirateBnt.titleLabel.font = UIFONT(15);
    [radioView addSubview:favirateBnt];
    favirateBnt.tag = 777;
    
    //分割线二
    UIView *divLine_2 = [[UIView alloc]initWithFrame:mRect(favirateBnt.right, radioView.height/4.0, 0.5, radioView.height/2.0)];
    divLine_2.backgroundColor = DIVLINECOLOR_1;
    [radioView addSubview:divLine_2];
    
    //价格
    priceBnt = [XHDHelper createButton:mRect(radioView.width/3.0*2.0+0.5, 0, radioView.width/3.0-0.5, radioView.height) NomalTitle:@"价格" SelectedTitle:@"价格" NomalTitleColor:DIVLINECOLOR_2 SelectTitleColor:THEMECOLOR_1 NomalImage:mImageByName(@"arrow_gary_down") SelectedImage:mImageByName(@"arrow_red_up") BoardLineWidth:0 target:self selector:@selector(buttonClickAction:)];
    [priceBnt setImageEdgeInsets:UIEdgeInsetsMake(0, 80, 0, 0)];
    [priceBnt setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    priceBnt.titleLabel.font = UIFONT(15);
    _markNum = 1;
    [radioView addSubview:priceBnt];
    priceBnt.tag = 888;
    
    
    //底部的线
    bottomLine = [[UIView alloc]initWithFrame:mRect(radioView.width/3.0/4, radioView.height-2, radioView.width/3.0/2,2)];
    bottomLine.backgroundColor = THEMECOLOR_1;
    [radioView addSubview:bottomLine];
    
    
}

/*radio选择的方法*/
- (void)buttonClickAction:(UIButton*)sender
{
    if(sender.tag==666)
    {
        totalBnt.selected = YES;
        favirateBnt.selected = NO;
        priceBnt.selected = NO;
        _markNum = 1;
        [priceBnt setTitleColor:DIVLINECOLOR_2 forState:UIControlStateNormal];
        [priceBnt setImage:mImageByName(@"arrow_gary_down") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            
           bottomLine.frame = mRect(radioView.width/3.0/4, radioView.height-2, radioView.width/3.0/2,2);
        }];
        _selectIndex = 1;
         [_workTable headerBeginRefreshing];
        
    
    }
    if(sender.tag==777)
    {
        totalBnt.selected = NO;
        favirateBnt.selected = YES;
        priceBnt.selected = NO;
        _markNum = 1;
        [priceBnt setTitleColor:DIVLINECOLOR_2 forState:UIControlStateNormal];
        [priceBnt setImage:mImageByName(@"arrow_gary_down") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            
         bottomLine.frame = mRect(radioView.width/3.0/4+radioView.width/3.0, radioView.height-2, radioView.width/3.0/2,2);
        }];
        _selectIndex = 2;
        [_workTable headerBeginRefreshing];
        
    }
    if(sender.tag==888)
    {
        totalBnt.selected = NO;
        favirateBnt.selected = NO;
         priceBnt.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
        bottomLine.frame = mRect(radioView.width/3.0/4+radioView.width/3.0*2, radioView.height-2, radioView.width/3.0/2,2);
        }];
        
        if(_markNum == 1)
        {
            _markNum = 2;
            priceBnt.selected = NO;
            [priceBnt setTitleColor:THEMECOLOR_1 forState:UIControlStateNormal];
            [priceBnt setImage:mImageByName(@"arrow_red_down") forState:UIControlStateNormal];
            _selectIndex = 4;
            [_workTable headerBeginRefreshing];
            
        } else if(_markNum == 2)
        {
            _markNum = 3;
            priceBnt.selected = YES;
            _selectIndex = 3;
            [_workTable headerBeginRefreshing];
            
        }else if(_markNum == 3)
        {
            _markNum = 2;
            priceBnt.selected = NO;
            _selectIndex = 4;
            [_workTable headerBeginRefreshing];
        }
    }
}

#pragma mark -- 请求网络
- (void)requestDataWithType:(NSInteger)type
{    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetSampleList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_mod.NPriceL forKey:@"NPriceL"];
    [parameterDic setValue:_mod.NPriceH forKey:@"NPriceH"];
    [parameterDic setValue:_mod.AveragePriceL forKey:@"AveragePriceL"];
    [parameterDic setValue:_mod.AveragePriceH forKey:@"AveragePriceH"];
    [parameterDic setValue:_mod.PerCouponL forKey:@"PerCouponL"];
    [parameterDic setValue:_mod.PerCouponH forKey:@"PerCouponH"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(type)] forKey:@"OrderType"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:kPageSize forKey:@"PageSize"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        [_workTable headerEndRefreshing];
        [_workTable footerEndRefreshing];
        if(page==1)
        {
            [_dataArr removeAllObjects];
        }
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                ExampleWorkModel *model=[[ExampleWorkModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
                [_dataArr addObject:model];
            }
            [_workTable reloadData];
        }
    } failure:^(NSError *error){
        [_workTable  headerEndRefreshing];
        [_workTable  footerEndRefreshing];
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    [self requestDataWithType:_selectIndex];
}
//TODO:加载更多
- (void)loadMoreData
{
    page++;
    [self requestDataWithType:_selectIndex];
}
#pragma mark -- 创建表
- (void)createTableView
{
    _dataArr = [[NSMutableArray alloc]init];
    _workTable = [[UITableView alloc]initWithFrame:mRect(0, radioView.bottom, kkDeviceWidth, kkDeviceHeight-64-radioView.height) style:UITableViewStylePlain];
    _workTable.delegate =self;
    _workTable.dataSource   = self;
    _workTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _workTable.backgroundColor = [UIColor clearColor];
    _workTable.showsVerticalScrollIndicator = NO;
    
    UINib *nib = [UINib nibWithNibName:@"ExampleWorkCell" bundle:[NSBundle mainBundle]];
    [_workTable registerNib:nib forCellReuseIdentifier:identfyName];
    
    [_workTable addHeaderWithTarget:self action:@selector(refreshData)];
    [_workTable addFooterWithTarget:self action:@selector(loadMoreData)];
     [_workTable headerBeginRefreshing];
    
    [self.view addSubview:_workTable];

}

#pragma mark -- tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExampleWorkCell*cell = [tableView dequeueReusableCellWithIdentifier:identfyName] ;
    if(_dataArr.count>0)
    {
        cell.mod = (ExampleWorkModel*)_dataArr[indexPath.row];
    }
    [cell reloadCellExampleList];
    cell.target = self;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExampleWorkCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *artID = cell.mod.ArtID;
    NSString *artPrice = cell.mod.Price;
    NSString *PMID = cell.mod.PMID;
    
    /*跳转到作品详情*/
    ExmapleWorkDetailVC *detail = [[ExmapleWorkDetailVC alloc]initWithArtID:artID AndArtPrice:artPrice PMID:PMID];
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark --tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 275.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
