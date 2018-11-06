//
//  FundViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "FundViewController.h"
#import "FundCell.h"
#import "FundModel.h"
#import "GetMopinFundViewController.h"
#import "CouponMainModel.h"
#import "InviteFriendViewController.h"
#import "LoginViewController.h"
#import "MyCouponModel.h"
#import "CommonEmptyTableBgView.h"

static NSString *kPageSize=@"10";
@interface FundViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_leftTableView;
    UITableView *_rightTableView;
    UIScrollView *_scrollView;
    NSMutableArray *_leftDataArr;
    NSMutableArray *_rightDataArr;
    PersonalInfoSingleModel *_personalModel;
    CommonEmptyTableBgView *_emptyBgView;
}
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@end

@implementation FundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"墨基金";
    _leftDataArr=[[NSMutableArray alloc]init];
    _rightDataArr=[[NSMutableArray alloc]init];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSLog(@"hidden %d",self.tabBarController.tabBar.hidden);
//    NSArray *titleArr=@[@"首次登录获得",@"邀请好友获得",@"首次定制获得"];
//    for(int i=0;i<3;i++){
//        FundModel *model=[[FundModel alloc]init];
//        model.Type=@"1";
//        if(i==0){
//            model.Amount=@"600";
//        }else{
//            model.Amount=@"800";
//        }
//        model.Expiretime=titleArr[i];
//        [_leftDataArr addObject:model];
//    }
//    if([mUserDefaults valueForKey:@"Login"]){
//        [_leftDataArr removeObjectAtIndex:0];
//    }
    page=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCouponMain) name:RefreshCoupon object:nil];
    [self createTbaleView];
    [self getCouponMain];
}
//TODO:获取墨品券
- (void)getCouponMain
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCouponMain" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    if(_personalModel.UserID.length==0){
        [parameterDic setValue:@"0" forKey:@"UserID"];
    }else{
        [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    }
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            [_leftDataArr removeAllObjects];
            
            for(NSDictionary *dic in jsonObject[@"data"]){
                CouponMainModel *model=[[CouponMainModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_leftDataArr addObject:model];
            }
        }
        [_leftTableView reloadData];
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
- (void)createTbaleView
{
    CGFloat height;
//    if(_type==1){
//        height=kkDeviceHeight-mNavBarHeight-44-mTabBarHeight;
//    }else{
        height=kkDeviceHeight-mNavBarHeight-44-mTabBarHeight;
//    }
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kkDeviceWidth, height)];
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(kkDeviceWidth*2, height);
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_scrollView];
    
    for(int i=0;i<2;i++){
        UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(kkDeviceWidth*i,0, kkDeviceWidth, height) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.backgroundColor=self.view.backgroundColor;
        tableView.separatorColor=[UIColor clearColor];
        [_scrollView addSubview:tableView];
        
        if (i==0) {
            _leftTableView=tableView;
            UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 100)];
            footerView.backgroundColor=_leftTableView.backgroundColor;
            
            for(int j=0;j<2;j++){
                UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.font=[UIFont boldSystemFontOfSize:15];
                button.frame=CGRectMake(20+((kkDeviceWidth-60)/2+20)*j,30, (kkDeviceWidth-60)/2, 50);
                if(j==0){
                    [button setTitle:@"领取墨品券" forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"red_button_fund.png"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(getMopinFund) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [button setTitle:@"领取书家券" forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageNamed:@"gray_button_fund.png"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(getShujiaFund) forControlEvents:UIControlEventTouchUpInside];
                }
                [footerView addSubview:button];
            }
            _leftTableView.tableFooterView=footerView;
            
        }else{
            _rightTableView=tableView;
            [_rightTableView addHeaderWithTarget:self action:@selector(refreshData)];
            [_rightTableView addFooterWithTarget:self action:@selector(loadMoreData)];
            
            _emptyBgView=[[CommonEmptyTableBgView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, GETVIEWHEIGHT(_rightTableView))];
            _emptyBgView.hidden = YES;
            _emptyBgView.tipsString=@"哦噢,还没有墨基金~";
            [_rightTableView addSubview:_emptyBgView];
        }
    }
}
//TODO:加载更多
- (void)loadMoreData
{
    page++;
    [self downloadFundList];
}
//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    [self downloadFundList];
}
//TODO:下载我的墨品券
- (void)downloadFundList
{
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MyCoupon" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
     [parameterDic setValue:@"0" forKey:@"PMID"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:kPageSize forKey:@"PageSize"];
    [parameterDic setValue:@"0" forKey:@"Type"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        [_rightTableView headerEndRefreshing];
        [_rightTableView footerEndRefreshing];
        if(page==1){
            [_rightDataArr removeAllObjects];
        }
        if (code.integerValue == 1000) {
            
            for(NSDictionary *dic in jsonObject[@"data"]){
                MyCouponModel *model=[[MyCouponModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_rightDataArr addObject:model];
            }
            if(_rightDataArr.count==0){
                _emptyBgView.hidden=NO;
            }else{
                _emptyBgView.hidden=YES;
            }
        }
        [_rightTableView reloadData];
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        [_rightTableView headerEndRefreshing];
        [_rightTableView footerEndRefreshing];
    }];
}
//TODO:获取书家券
- (void)getShujiaFund
{
    if(!_personalModel.isLogin){
        [self login];
        return;
    }
    GetMopinFundViewController *gmvc=[[GetMopinFundViewController alloc]init];
    gmvc.hidesBottomBarWhenPushed=YES;
    gmvc.type=2;
    [self.navigationController pushViewController:gmvc animated:YES];
}
//TODO:获取墨品券
- (void)getMopinFund
{
    if(!_personalModel.isLogin){
        [self login];
        return;
    }
    
    GetMopinFundViewController *gmvc=[[GetMopinFundViewController alloc]init];
    gmvc.hidesBottomBarWhenPushed=YES;
    gmvc.type=1;
    [self.navigationController pushViewController:gmvc animated:YES];
}
- (IBAction)getFundBtnClick:(id)sender {
    [_scrollView scrollRectToVisible:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-44) animated:YES];
}
- (IBAction)MyFundBtnClick:(id)sender {
    if(!_personalModel.isLogin){
        [self login];
        return;
    }
    
    [_scrollView scrollRectToVisible:CGRectMake(kkDeviceWidth, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-44) animated:YES];
}
#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_personalModel.isLogin){
        if(scrollView.contentOffset.x>0){
            [self login];
            return;
        }
    }
    
    if(_scrollView==scrollView){
        _lineImageView.frame=CGRectMake((kkDeviceWidth/2-80)/2+scrollView.contentOffset.x/kkDeviceWidth*kkDeviceWidth/2,42, 80, 2);
        
        if(page==0 && scrollView.contentOffset.x==kkDeviceWidth){
            [_rightTableView headerBeginRefreshing];
        }
    }
}
#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_leftTableView){
        return _leftDataArr.count;
    }
    return _rightDataArr.count;
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
    if(tableView==_leftTableView){
        CouponMainModel *model=_leftDataArr[indexPath.row];
        [cell reloadCellWithCouponModel:model];
    }else{
        MyCouponModel *model=_rightDataArr[indexPath.row];
        [cell reloadcellWithMyCouponModel:model];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_leftTableView==tableView){
        CouponMainModel *model=_leftDataArr[indexPath.row];
        if(model.Type.intValue==1){ //登录
            [self login];
        }else if(model.Type.intValue==2){ //分享
            if(!_personalModel.isLogin){
                [self login];
                return;
            }
            InviteFriendViewController *ifvc=[[InviteFriendViewController alloc]init];
            ifvc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:ifvc animated:YES];
        }else if(model.Type.intValue==3){ //首单
            
        }
    }
}
//TODO:登录
- (void)login
{
    LoginViewController *lvc=[[LoginViewController alloc]init];
    lvc.formVCTag=1;
    lvc.hidesBottomBarWhenPushed=YES;
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:lvc];
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
