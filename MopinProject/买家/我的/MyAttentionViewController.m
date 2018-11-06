//
//  MyAttentionViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/11.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "PenmanListModel.h"
#import "PenmanListCell.h"
#import "PenmanDetailViewController.h"
#import "CommonEmptyTableBgView.h"

static const NSString *kPageSize=@"10";
@interface MyAttentionViewController ()<UITableViewDataSource,UITableViewDelegate,PenmanListCellDelegate>

@end

@implementation MyAttentionViewController
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    PersonalInfoSingleModel *_personalMdoel;
    CommonEmptyTableBgView *_emptyBgView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"我的关注";
    [self setNavBackBtnWithType:1];
    
    _dataArr=[[NSMutableArray alloc]init];
    _personalMdoel=[PersonalInfoSingleModel shareInstance];
    [self createTableView];
}
//TODO:下载
- (void)downlaodMyFavorites
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MyAttention" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalMdoel.UserID forKey:@"UserID"];
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
                PenmanListModel *model=[[PenmanListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            
            if(_dataArr.count==0){
                _emptyBgView.hidden=NO;
            }else{
                _emptyBgView.hidden=YES;
            }
        }
        [_tableView reloadData];

    } failure:^(NSError *error){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:创建tableView
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStylePlain];
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [_tableView headerBeginRefreshing];
    
    _emptyBgView=[[CommonEmptyTableBgView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight)];
    _emptyBgView.hidden = YES;
    _emptyBgView.tipsString=@"哦噢,还没有关注书家~";
    [_tableView addSubview:_emptyBgView];
}
//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    [self downlaodMyFavorites];
}
//TODO:加载更多
- (void)loadMoreData
{
    page++;
    [self downlaodMyFavorites];
}
#pragma mark - PenmanListCellDelegate
- (void)cancelAttentionWithModel:(PenmanListModel *)model
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"AttendPenmanDeal" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalMdoel.UserID forKey:@"UserID"];
    [parameterDic setValue:@"2" forKey:@"State"];
    [parameterDic setValue:model.UserID forKey:@"PenmanID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            [_dataArr removeObject:model];
            [_tableView reloadData];
            if(_dataArr.count==0){
                _emptyBgView.hidden=NO;
            }
        }
    } failure:^(NSError *error){
        
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
    return 265.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PenmanListCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"PenmanListCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PenmanListCell" owner:self options:nil]firstObject];
    }
    if(_dataArr.count!=0){
        PenmanListModel *model=_dataArr[indexPath.row];
        cell.model=model;
        [cell reloadCellInMineAttention];
        cell.delegate=self;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PenmanListModel *model=_dataArr[indexPath.row];
    PenmanDetailViewController *pdvc=[[PenmanDetailViewController alloc]initWithNibName:@"PenmanDetailViewController" bundle:nil];
    pdvc.penmanID=model.UserID;
    [self.navigationController pushViewController:pdvc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
