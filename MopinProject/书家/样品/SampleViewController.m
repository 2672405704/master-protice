//
//  SampleViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SampleViewController.h"
#import "MineListCell.h"
#import "OnSaleViewController.h"
#import "IssueSampleViewController.h"

@interface SampleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
}
@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"样品";
    _titleArr=@[@"发布样品",@"上架样品",@"下架样品"];
    
    [self createTbaleView];
}
//TODO:创建tableView
- (void)createTbaleView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableFooterView=[[UIView alloc]init];
    _tableView.backgroundColor=self.view.backgroundColor;
    [self.view addSubview:_tableView];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineListCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"MineListCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    }
    cell.titleLabel.text=_titleArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        IssueSampleViewController *isvc=[[IssueSampleViewController alloc]init];
        isvc.hidesBottomBarWhenPushed=YES;
        isvc.type=0;
        [self.navigationController pushViewController:isvc animated:YES];
//        PublishSampleViewController *isvc=[[PublishSampleViewController alloc]init];
//        isvc.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:isvc animated:YES];
    }else if(indexPath.row==1){
        OnSaleViewController *osvc=[[OnSaleViewController alloc]init];
        osvc.hidesBottomBarWhenPushed=YES;
        osvc.type=1;
        [self.navigationController pushViewController:osvc animated:YES];
    }else{
        OnSaleViewController *osvc=[[OnSaleViewController alloc]init];
        osvc.hidesBottomBarWhenPushed=YES;
        osvc.type=2;
        [self.navigationController pushViewController:osvc animated:YES];
    }
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


@end
