//
//  AllSampleViewController.m
//  MopinProject
//
//  Created by rt008 on 16/1/7.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "AllSampleViewController.h"
#import "PenmanDetailSampleModel.h"
#import "PenmanDetailSampleCell.h"
#import "CommonEmptyTableBgView.h"
#import "ExmapleWorkDetailVC.h"

static NSString const *kPageSize=@"10";
@interface AllSampleViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AllSampleViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    CommonEmptyTableBgView *_emptyBgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [mNotificationCenter addObserver:self selector:@selector(refreshData) name:RefreshPenmanAllSampleList object:nil];
    
    self.navigationItem.title=@"全部样品";
    [self setNavBackBtnWithType:1];
    _dataArr=[[NSMutableArray alloc]init];
    
    [self createTableView];
}
//TODO:创建tableview
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [_tableView headerBeginRefreshing];
    
    _emptyBgView=[[CommonEmptyTableBgView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-45)];
    _emptyBgView.hidden = YES;
    _emptyBgView.tipsString=@"哦噢,还没有样品~";
    [_tableView addSubview:_emptyBgView];
}
//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    [self downloadSampleList];
}
//TODO:上拉加载更多
- (void)loadMoreData
{
    page++;
    [self downloadSampleList];
}
//TODO:下载书家样品列表
- (void)downloadSampleList
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"PMSampleList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_penmanId forKey:@"PMID"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID.length?[PersonalInfoSingleModel shareInstance].UserID:@"0" forKey:@"UserID"];
    
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:kPageSize forKey:@"PageSize"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        if(page==1){
            [_dataArr removeAllObjects];
        }
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"]){
                PenmanDetailSampleModel *model=[[PenmanDetailSampleModel alloc]init];
                
                /*手动匹配参数*/
                model.ProductName = dic[@"ArtName"];//名称
                model.ArtID = dic[@"ArtID"];//ID
                model.ShowType = dic[@"ShowType"];//展示
                model.WordType = dic[@"WordType"];//内容
                model.Size = dic[@"Size"];//样品尺寸
                model.ArtPic = dic[@"ArtPic"];//样品图片
                model.Price = dic[@"Price"];//价格
                model.CouponsRatio = dic[@"CouponsRatio"];//可用劵
                model.IsZan = dic[@"IsZan"];
                model.ZanNum = dic[@"ZanNum"];
                model.CollectNum = dic[@"CollectNum"];
                model.IsCollect = dic[@"IsCollect"];
                model.BookedNum = dic[@"BookedNum"];
                model.IsPublicGoodSample = dic[@"IsPublicGoodSample"];
                
                [_dataArr addObject:model];
            }
            if(_dataArr.count==0){
                _emptyBgView.hidden=NO;
            }else{
                _emptyBgView.hidden=YES;
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
    
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 425.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PenmanDetailSampleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PenmanDetailSampleCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PenmanDetailSampleCell" owner:self options:nil] firstObject];
        cell.backgroundColor=self.view.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(_dataArr.count!=0){
        
        PenmanDetailSampleModel *model=_dataArr[indexPath.row];
        cell.model = model;
        
    }
    return cell;
}
//TODO:让tableView的分割线从头开始
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PenmanDetailSampleModel *model = _dataArr[indexPath.row];
    
    ExmapleWorkDetailVC *evc=[[ExmapleWorkDetailVC alloc]initWithArtID:model.ArtID AndArtPrice:model.Price
                              PMID:_penmanId];
    
    [self.navigationController pushViewController:evc animated:YES];



}
- (void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
