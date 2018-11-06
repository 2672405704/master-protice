//
//  PenmanListViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PenmanListViewController.h"
#import "PenmanListCell.h"
#import "PenmanListModel.h"
#import "PenmanDetailViewController.h"
#import "SearchViewController.h"
#import "CommonEmptyTableBgView.h"

static NSString const *kPageSize=@"10";
@interface PenmanListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    NSInteger _selecterIndex;
    CommonEmptyTableBgView *_emptyBgView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIImageView *redLineImageView;
@end

@implementation PenmanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"书法家";
    [self setNavBackBtnWithType:1];
    [self setRightNavImageIconWithFrame:CGSizeMake(21, 21) andImageStr:@"search_home.png"];
    _selecterIndex=1;
    _dataArr=[[NSMutableArray alloc]init];
    
    [self createTbaleView];
}
//TODO:点击搜索
- (void)rightNavBtnClick
{
    SearchViewController *svc=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    svc.type=SearchhTypePenman;
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:svc];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}
- (void)createTbaleView
{
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [_tableView headerBeginRefreshing];
    
    _emptyBgView=[[CommonEmptyTableBgView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-45)];
    _emptyBgView.hidden = YES;
    _emptyBgView.tipsString=@"哦噢,还没有书法家~";
    [_tableView addSubview:_emptyBgView];
}
//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    [self downloadtPenmanListWithType:_selecterIndex];
}
//TODO:加载更多
- (void)loadMoreData
{
    page++;
    [self downloadtPenmanListWithType:_selecterIndex];
}
//TODO:下载书家列表
- (void)downloadtPenmanListWithType:(NSInteger)type
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetPenmanList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_PenmanType forKey:@"PenmanType"];
    [parameterDic setValue:_ProviceID forKey:@"ProviceID"];
    [parameterDic setValue:_CityID forKey:@"CityID"];
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
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];

}
- (IBAction)priceBtnClick:(id)sender {
    if(_selecterIndex<3){
        UIButton *btn=(UIButton *)[self.view viewWithTag:100+_selecterIndex-1];
        btn.selected=NO;
    }
    [_priceBtn setImage:[UIImage imageNamed:@"arrow_red_up.png"] forState:UIControlStateNormal];
    [_priceBtn setTitleColor:toPCcolor(@"ca2b3b") forState:UIControlStateNormal];
    _priceBtn.selected=!_priceBtn.selected;
    if(_priceBtn.selected){
        _selecterIndex=3;
    }else{
        _selecterIndex=4;
    }
    [_tableView headerBeginRefreshing];
    //改变线条的位置
    [UIView animateWithDuration:0.3 animations:^{
        _redLineImageView.frame=CGRectMake((kkDeviceWidth/3-60)/2*3+(60+(kkDeviceWidth/3-60)/2)*(3-1), 43, 60, 2);
    }];
}
- (IBAction)sortBtnClick:(id)sender {
    _priceBtn.selected=NO;
    [_priceBtn setImage:[UIImage imageNamed:@"arrow_gary_down.png"] forState:UIControlStateNormal];
    [_priceBtn setTitleColor:toPCcolor(@"888888") forState:UIControlStateNormal];
    
    UIButton *button=(UIButton *)sender;
    if(_selecterIndex==button.tag-100+1){
        if(button==_priceBtn){
            
        }
        return;
    }else{
        UIButton *btn=(UIButton *)[self.view viewWithTag:_selecterIndex+100-1];
        btn.selected=NO;
        button.selected=YES;
    }
    _selecterIndex=button.tag-100+1;
    //改变线条的位置
    [UIView animateWithDuration:0.3 animations:^{
        _redLineImageView.frame=CGRectMake((kkDeviceWidth/3-60)/2*_selecterIndex+(60+(kkDeviceWidth/3-60)/2)*(_selecterIndex-1), 43, 60, 2);
    }];
    [_tableView headerBeginRefreshing];
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 305.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PenmanListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PenmanListCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PenmanListCell" owner:self options:nil] firstObject];
    }
    if(_dataArr.count!=0){
        PenmanListModel *model=_dataArr[indexPath.row];
        cell.model=model;
        [cell reloadCell];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PenmanListModel *model=_dataArr[indexPath.row];
    PenmanDetailViewController *pdvc=[[PenmanDetailViewController alloc]initWithNibName:@"PenmanDetailViewController" bundle:nil];
    pdvc.penmanID=model.UserID;
    [self.navigationController pushViewController:pdvc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
