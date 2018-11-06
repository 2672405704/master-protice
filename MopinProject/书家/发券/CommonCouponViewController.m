//
//  CommonCouponViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CommonCouponViewController.h"
#import "MineListCell.h"
#import "GiveCouponViewController.h"
#import "NormalCouponModel.h"

@interface CommonCouponViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArr;
    NSMutableArray *_dataArr;
}
@end

@implementation CommonCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"常规发券";
    [self setNavBackBtnWithType:1];
    
    _titleArr=@[@"关注我",@"分享给好友",@"首次成功定制"];
    _dataArr=[[NSMutableArray alloc]init];
    
    [self createTableView];
    [self getNormalCoupon];
}
- (void)getNormalCoupon
{
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetNormalCoupon" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"]){
                NormalCouponModel *model=[[NormalCouponModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArr addObject:model];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        
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
    [self.view addSubview:_tableView];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineListCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"MineListCell" owner:self options:nil]firstObject];
    if(_titleArr.count>0)
    {
        cell.titleLabel.text=_titleArr[indexPath.row];
    }
    cell.rightLabel.hidden=NO;
    NormalCouponModel *model=_dataArr[indexPath.row];
    if(model.IsOpen.intValue==0){
        cell.rightLabel.textColor=toPCcolor(@"888888");
        cell.rightLabel.text=@"已关闭";
    }else{
        cell.rightLabel.textColor=toPCcolor(@"ca2b3b");
        cell.rightLabel.text=[NSString stringWithFormat:@"赠送%@元",model.Amount];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GiveCouponViewController *gcvc=[[GiveCouponViewController alloc]initWithNibName:@"GiveCouponViewController" bundle:nil];
    gcvc.model=_dataArr[indexPath.row];
    gcvc.type=indexPath.row+1;
    [gcvc setResetNormalCoupon:^{
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:gcvc animated:YES];
    
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
