//
//  EvaluateManagerViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "EvaluateManagerViewController.h"
#import "EvaluteSampleCell.h"
#import "EvaluteListModel.h"
#import "ReplyEvaluteViewController.h"

static NSString *kPageSize=@"10";
@interface EvaluateManagerViewController ()<UITableViewDataSource,UITableViewDelegate,EvaluteSampleCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@end

@implementation EvaluateManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"评价管理";
    _dataArr=[[NSMutableArray alloc]init];
    [self setNavBackBtnWithType:1];
    
    [self createTableView];
}
//TODO:下载评价列表
- (void)downloadEvaluteList
{
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCommentList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"ID"];
    [parameterDic setValue:@"0" forKey:@"IDType"];
    [parameterDic setValue:@"0" forKey:@"TagID"];
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
                EvaluteListModel *model=[[EvaluteListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
                for(NSDictionary *image in dic[@"ImageData"]){
                    [model.ImageData addObject:image[@"EPicPath"]];
                }
                [_dataArr addObject:model];
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
//TODO:创建tableView
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView addHeaderWithTarget:self action:@selector(refeshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [self.view addSubview:_tableView];
    
    [_tableView headerBeginRefreshing];
}
//TODO:刷新
- (void)refeshData
{
    page=1;
    [self downloadEvaluteList];
}
//TODO:加载更多
- (void)loadMoreData
{
    page++;
    [self downloadEvaluteList];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EvaluteSampleCell getHeightWithModel:_dataArr[indexPath.row]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluteSampleCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"EvaluteSampleCell" owner:self options:nil]firstObject];
    
    EvaluteListModel *model;
    if(_dataArr.count!=0){
        
        model=_dataArr[indexPath.row];
    }
//    if(_type==EvaluateManagerVCNormal){
        cell.model=_dataArr[indexPath.row];
        cell.delegate=self;
        [cell reloadCell];
//    }else{
//        
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        
    }else if(indexPath.row==3){
        
    }else if(indexPath.row==4){
        
    }
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
#pragma mark EvaluteSampleCellDelegate
//TODO:置顶
- (void)stickEvaluteList:(EvaluteListModel *)model
{
    [_dataArr removeObject:model];
    [_dataArr insertObject:model atIndex:0];
    [_tableView reloadData];
}
//TODO:回复
- (void)replyEvalute:(EvaluteListModel *)model
{
    ReplyEvaluteViewController *revc=[[ReplyEvaluteViewController alloc]initWithNibName:@"ReplyEvaluteViewController" bundle:nil];
    revc.model=model;
    [revc setReloadCell:^{
        [_tableView headerBeginRefreshing];
    }];
    [self.navigationController pushViewController:revc animated:YES];
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
