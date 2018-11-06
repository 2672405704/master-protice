//
//  OnSaleViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "OnSaleViewController.h"
#import "OnSaleCell.h"
#import "SampleModel.h"
#import "IssueSampleViewController.h"
#import "PublishSampleModel.h"
#import "SampleAttributeModel.h"
#import "RecommendContentModel.h"
#import "SamplePicModel.h"
#import "ImageModel.h"

static NSString *kPageSize=@"10";
@interface OnSaleViewController ()<UITableViewDataSource,UITableViewDelegate,OnSaleCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    PersonalInfoSingleModel *_personalModel;
}
@end

@implementation OnSaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(_type==1){
        self.navigationItem.title=@"上架样品";
    }else{
        self.navigationItem.title=@"下架样品";
    }
    [self setNavBackBtnWithType:1];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    _dataArr=[[NSMutableArray alloc]init];
    
    [self createTbaleView];
}
//TODO:下载样品
- (void)downloadSampleList
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SampleManage" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];

    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(_type)] forKey:@"IsOnSale"];

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
                SampleModel *model=[[SampleModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
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
- (void)createTbaleView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]init];
//    _tableView.separatorColor=[UIColor clearColor];
    _tableView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:_tableView];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [_tableView headerBeginRefreshing];
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
#pragma mark - onSaleCellDelegate
//TODO:编辑
- (void)editSample:(SampleModel *)model
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetSampleDetailForEdit" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:model.ArtID forKey:@"ArtID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            NSDictionary *dic=jsonObject[@"data"][0];
            PublishSampleModel *publishModel=[[PublishSampleModel alloc]init];
            [publishModel setValuesForKeysWithDictionary:dic];
            publishModel.WordTypeModel.AttributeCode=dic[@"WordType"];
            publishModel.ShowTypeModel.AttributeCode=dic[@"ShowType"];
            publishModel.MaterialCodeModel.AttributeCode=dic[@"MaterialCode"];
            publishModel.DeliveryTimeCodeModel.AttributeCode=dic[@"DeliveryTimeCode"];
            //推荐语
            NSMutableArray *tempArr=[NSMutableArray array];
            if([dic[@"RCData"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *RCDic in dic[@"RCData"]){
                    RecommendContentModel *model=[[RecommendContentModel alloc]init];
                    [model setValuesForKeysWithDictionary:RCDic];
                    [tempArr addObject:model];
                }
            }
            publishModel.RCIDList=[NSArray arrayWithArray:tempArr];
            //图片
            [tempArr removeAllObjects];
            for(NSDictionary *picDic in dic[@"SamplePicData"]){
                ImageModel *model=[[ImageModel alloc]init];
                model.Image=picDic[@"SamplePicPath"];
                model.ID=picDic[@"SamplePicID"];
                [tempArr addObject:model];
            }
            publishModel.SamplePicArr=[NSArray arrayWithArray:tempArr];
            //适用场所
            [tempArr removeAllObjects];
            for(NSString *IDStr in [dic[@"PlaceCode"] componentsSeparatedByString:@","]){
                SampleAttributeModel *model=[[SampleAttributeModel alloc]init];
                model.AttributeCode=IDStr;
                [tempArr addObject:model];
            }
            publishModel.PlaceCodeArr=[NSArray arrayWithArray:tempArr];
            //适用用途
            [tempArr removeAllObjects];
            for(NSString *IDStr in [dic[@"UsedCode"] componentsSeparatedByString:@","]){
                SampleAttributeModel *model=[[SampleAttributeModel alloc]init];
                model.AttributeCode=IDStr;
                [tempArr addObject:model];
            }
            publishModel.UsedCodeArr=[NSArray arrayWithArray:tempArr];
            
            publishModel.ArtID=model.ArtID;
            IssueSampleViewController *isvc=[[IssueSampleViewController alloc]init];
            isvc.model=publishModel;
            isvc.hidesBottomBarWhenPushed=YES;
            isvc.type=0;
            [self.navigationController pushViewController:isvc animated:YES];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:置顶
- (void)stickSample:(SampleModel *)model
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SampleTop" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:model.ArtID forKey:@"ArtID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            
            [_dataArr removeObject:model];
            [_dataArr insertObject:model atIndex:0];
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:删除
- (void)deleteSample:(SampleModel *)model
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"DelSample" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:model.ArtID forKey:@"ArtID"];
    
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
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:下架
- (void)soldOutSample:(SampleModel *)model
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SampleOff" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:model.ArtID forKey:@"ArtID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            //保存ID
            [_dataArr removeObject:model];
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
//TODO:上架样品管理
- (void)upStoreSample:(SampleModel *)model
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SampleOn" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:model.ArtID forKey:@"ArtID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            //保存ID
            [_dataArr removeObject:model];
            [_tableView reloadData];
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
    return 180.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OnSaleCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"OnSaleCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"OnSaleCell" owner:self options:nil]firstObject];
    }
    SampleModel *model=_dataArr[indexPath.row];
    cell.sampleModel=model;
    cell.delegate=self;
    [cell reloadCellWithType:_type];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
