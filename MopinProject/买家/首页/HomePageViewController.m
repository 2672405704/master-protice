//
//  HomePageViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageCell.h"
#import "HomePageModel.h"
#import "ChoosePenManView.h"
#import "NMRangeSlider.h"
#import "PriceCustomizationView.h"
#import "GetSampleListModel.h"
#import "PenmanListViewController.h"
#import "SearchViewController.h"
#import "ExampleWorkVC.h"
#import "ActivityWebVC.h"
#import "PenmanDetailViewController.h"
#import "ExmapleWorkDetailVC.h"

@interface HomePageViewController ()<UITableViewDataSource,UITableViewDelegate,ChoosePenManViewDelegate,PriceCustomizationViewDelegate>
{
    NSMutableArray *_dataArr;
    ChoosePenManView *_penManView;
    PriceCustomizationView *_priceView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *penmanBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"墨品定制";
    [self setRightNavImageIconWithFrame:CGSizeMake(21, 21) andImageStr:@"search_home.png"];
    _dataArr=[[NSMutableArray alloc]init];
    _penmanBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:15];
    _priceBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:15];
    
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView headerBeginRefreshing];
}
- (void)refreshData
{
    [self getMainList];
}
//TODO:点击右边按钮
- (void)rightNavBtnClick
{
    SearchViewController *svc=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:svc];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}
//TODO:按价格定制
- (IBAction)prcieBtnClick:(id)sender {
    if(!_priceView){
        _priceView=[[[NSBundle mainBundle] loadNibNamed:@"PriceCustomizationView" owner:self options:nil]firstObject];
        _priceView.delegate=self;
        [WINDOW addSubview:_priceView];
    }else{
        _priceView.hidden=NO;
    }
}
#pragma mark - PriceCustomizationViewDelegate
//TODO:跳到按价格筛选出的样品
- (void)priceCustomizationWithModel:(GetSampleListModel *)model
{
    ExampleWorkVC *exampleList = [[ExampleWorkVC alloc]initWithModel:model];
    exampleList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:exampleList animated:YES];
}
//TODO:找到心仪的书家
- (IBAction)findPenman:(id)sender {
    if(!_penManView){
        _penManView=[[[NSBundle mainBundle] loadNibNamed:@"ChoosePenManView" owner:self options:nil]firstObject];
        _penManView.delegate=self;
        [WINDOW addSubview:_penManView];
    }else{
        _penManView.hidden=NO;
    }
}



#pragma mark - ChoosePenManViewDelegate
- (void)choosePenView:(NSString *)proviceId andCityId:(NSString *)cityId andPenmanType:(NSString *)type
{
    PenmanListViewController *plvc=[[PenmanListViewController alloc]initWithNibName:@"PenmanListViewController" bundle:nil];
    plvc.PenmanType=type;
    plvc.ProviceID=proviceId;
    plvc.CityID=cityId;
    plvc.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:plvc animated:YES];
}
//TODO:获取列表
- (void)getMainList
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetMainList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        [_tableView headerEndRefreshing];
        if (code.integerValue == 1000) {
            [_dataArr removeAllObjects];
            for(NSDictionary *dic in jsonObject[@"data"]){
                HomePageModel *model=[[HomePageModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
                [_dataArr addObject:model];
            }
            
            [_tableView reloadData];
        }
    } failure:^(NSError *error){
        [_tableView headerEndRefreshing];
        
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
    return kkDeviceWidth*2/3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"HomePageCell"];
    if(!cell){
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HomePageCell" owner:self options:nil] firstObject];
    }
    if(_dataArr.count>0)
    {
        HomePageModel *model=_dataArr[indexPath.row];
        [cell reloadCellWithModel:model];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
   
    HomePageModel *model=_dataArr[indexPath.row];
    if([model.Type2 isEqualToString:@"2"])
    {
        /*跳到活动页面*/
        NSURL *jumpURL = [NSURL URLWithString:model.JumpPath];
        if(jumpURL)
        {
            ActivityWebVC *webVc = [[ActivityWebVC alloc]initWithURL:jumpURL];
            webVc.titleName = model.JumpTitle;
            webVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVc animated:YES];
        }
    }
    else
    {
        if([model.Type isEqualToString:@"3"])//3商品详情：App跳转
        {
            ExmapleWorkDetailVC *detail = [[ExmapleWorkDetailVC alloc]initWithArtID:model.ItemID                        AndArtPrice:@"0.00" PMID:@"0"];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
        else if([model.Type isEqualToString:@"4"])//3商品详情：App跳转
        {
            PenmanDetailViewController *detail = [[PenmanDetailViewController alloc]init];
            detail.penmanID = model.ItemID;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
        }
    
    }
    
    
}

- (void)dealloc
{
    [_priceView removeFromSuperview];
    [_penManView removeFromSuperview];
    _priceView=nil;
    _penManView=nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"hidden %d",self.tabBarController.tabBar.hidden);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
