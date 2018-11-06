//
//  TicketViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "TicketViewController.h"
#import "MineListCell.h"
#import "CommonCouponViewController.h"
#import "PrivateCouponViewController.h"
#import "SquareCouponViewController.h"

@interface TicketViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    NSArray *_infoArr;
}
@end

@implementation TicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"发券";
    _titleArr=@[@"常规发券",@"指定发券",@"广场发券"];
    _infoArr=@[@"关注/首次定制/分享好友",@"指定向某人发券",@"在领券广场发券"];
    
    [self createTableView];
}
//TODO:创建tableView
- (void)createTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-mTabBarHeight) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=self.view.backgroundColor;
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infoArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineListCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    cell.titleLabel.text=_titleArr[indexPath.row];
    cell.rightLabel.hidden=NO;
    cell.rightLabel.font=[UIFont systemFontOfSize:14];
    cell.rightLabel.textColor=toPCcolor(@"888888");
    cell.rightLabel.text=_infoArr[indexPath.row];
    cell.rightLabel.textAlignment=NSTextAlignmentLeft;
    cell.rightLabel.frame=CGRectMake(120, 11, kkDeviceWidth-120-50, 21);
    [cell.rightLabel size];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        CommonCouponViewController *ccvc=[[CommonCouponViewController alloc]init];
        ccvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:ccvc animated:YES];
    }else if(indexPath.row==1){
        PrivateCouponViewController *pvc=[[PrivateCouponViewController alloc]initWithNibName:@"PrivateCouponViewController" bundle:nil];
        pvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pvc animated:YES];
    }else if(indexPath.row==2){
        SquareCouponViewController *scvc=[[SquareCouponViewController alloc]initWithNibName:@"SquareCouponViewController" bundle:nil];
        scvc.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:scvc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
