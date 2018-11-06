//
//  GetMopinFundViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "GetMopinFundViewController.h"
#import "FundCell.h"
#import "FundModel.h"
#import "CouponMainModel.h"
#import "MyCouponModel.h"
#import "CouponMopinModel.h"
#import "PenmanDetailViewController.h"
#import "CommonEmptyTableBgView.h"

static NSString const *kPageSize=@"10";
@interface GetMopinFundViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    CommonEmptyTableBgView *_emptyBgView;
}
@end

@implementation GetMopinFundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr=[[NSMutableArray alloc]init];
    [self setNavBackBtnWithType:1];
    [self createTableView];
    if(_type==1){
        self.navigationItem.title=@"领取墨品券";
        [self getMPCouponList];
    }else if(_type==2){
        self.navigationItem.title=@"领取书家券";
        [self getPenmanCouponList];
    }else{
        self.navigationItem.title=@"我的墨基金";
    }
}
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.separatorColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _emptyBgView=[[CommonEmptyTableBgView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight)];
    _emptyBgView.hidden = YES;
    [_tableView addSubview:_emptyBgView];
    if(_type==1){
        _emptyBgView.tipsString=@"哦噢,还没有可领取的墨品券~";
    }else if (_type==2){
        _emptyBgView.tipsString=@"哦噢,还没有可领取的书家券~";
    }else if(_type==3){
        [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
        [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
        
        [_tableView headerBeginRefreshing];
        
        _emptyBgView.tipsString=@"哦噢,还没有墨基金~";
    }
}
//TODO:加载更多
- (void)loadMoreData
{
    page++;
    [self getMyCoupon];
}
//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    [self getMyCoupon];
}
//TODO:下载我的墨品券
- (void)getMyCoupon
{
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MyCoupon" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:kPageSize forKey:@"PageSize"];
    [parameterDic setValue:@"0" forKey:@"Type"];
    [parameterDic setValue:@"0" forKey:@"PMID"];
    
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
                MyCouponModel *model=[[MyCouponModel alloc]init];
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
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }];
}
//TODO:获取书家券
- (void)getPenmanCouponList
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetPenmanCouponList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"]){
                FundModel *model=[[FundModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            [_tableView reloadData];
            
            if(_dataArr.count==0){
                _emptyBgView.hidden=NO;
            }else{
                _emptyBgView.hidden=YES;
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:获取墨品券
- (void)getMPCouponList
{
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetMPCouponList" forKey:@"Method"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"]){
                CouponMopinModel *model=[[CouponMopinModel alloc]init];
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
    return 120.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundCell *cell=[tableView dequeueReusableCellWithIdentifier:@"FundCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"FundCell" owner:self options:nil]firstObject];
    }
    if(_type==1){
        CouponMopinModel *model=_dataArr[indexPath.row];
        [cell reloadCellWithMopinModel:model];
    }else if(_type==2){
        FundModel *model=_dataArr[indexPath.row];
        [cell reloadCellWithModel:model];
    }else{
        if(_dataArr.count!=0){
            MyCouponModel *model=_dataArr[indexPath.row];
            [cell reloadcellWithMyCouponModel:model];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_type==1){
        CouponMopinModel *model=_dataArr[indexPath.row];
        [self getMPCouponWithModel:model];
    }else if(_type==2){
        FundModel *model=_dataArr[indexPath.row];
        PenmanDetailViewController *pdvc=[[PenmanDetailViewController alloc]initWithNibName:@"PenmanDetailViewController" bundle:nil];
        pdvc.penmanID=model.UserID;
        [self.navigationController pushViewController:pdvc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)getMPCouponWithModel:(CouponMopinModel *)model
{
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCoupon" forKey:@"Method"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:model.BatchID forKey:@"BatchID"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
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
