//
//  MyCustomListVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "MyCustomListVC.h"
#import "UIRadioControl.h"
#import "MyCustomListCell.h"
#import "ApplyServiceVC.h"
#import "LogisticsInfoVC.h"
#import "MyOrderModel.h"
#import "MJRefresh.h"
#import "PublishCommentVC.h"
#import "ComfireOrderVC.h"  //确认订单
#import "MoveJJViewController.h"
#import "MyOrderDetailVC.h"
#import "ChoosePayTypeVC.h"
#import "CommonEmptyTableBgView.h"



#define LocStr(key) NSLocalizedString(key,@"")


@interface MyCustomListVC ()<UIAlertViewDelegate> {
     UIRadioControl *radio;
    int _selectIdx;       //选中的ID
    int lasteSelectIndex; //上次选中的ID
    NSString *query_type;                 // 投注记录的类型
    
    UIImageView *_radioBottomImageView;//滑动条
    UIScrollView *_horizontalScrollView;// 水平滑动的ScrollView
    UIView *bgView;
    NSInteger _page_num;      //页数
    NSUInteger _page_size;    //每一页显示的数量
    NSUInteger _total_num;   //总记录数
    NSUInteger _total_page;   //总页数
    NSString *_identify;
    PersonalInfoSingleModel *_personalModel;
    float itemWidth;
    NSString *orderCode_1; //第一个按钮传过来的订单ID
    NSString *orderCode_2; //第二个按钮传过来的订单ID
    
    /*四个空载页*/
    CommonEmptyTableBgView *emptyBgView_1;
    CommonEmptyTableBgView *emptyBgView_2;
    CommonEmptyTableBgView *emptyBgView_3;
    CommonEmptyTableBgView *emptyBgView_4;

}

@property(nonatomic,strong)NSMutableArray *allData;  //所有
@property(nonatomic,strong)NSMutableArray *doingData; //进行中
@property(nonatomic,strong)NSMutableArray *waitCommentData; //待评价
@property(nonatomic,strong)NSMutableArray *finishData; //已完成




@end

@implementation MyCustomListVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.orderData = [NSMutableArray new];
        
        self.allData = [NSMutableArray new];
        self.doingData = [NSMutableArray new];
        self.waitCommentData = [NSMutableArray new];
        self.finishData = [NSMutableArray new];
    }
    return self;
}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"我的定制";
    [self setNavBackBtnWithType:1];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建4个tableView
    [self _initContentView];
    
    
    
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderAActionNotification:) name:@"OrderAActionNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OrderBActionNotification:) name:@"OrderBActionNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyOrderList:) name:@"updateMyOrderList" object:nil];
    
    
}

- (void)updateMyOrderList:(NSNotification *)notification {
    
    NSLog(@"评价回来刷新列表。。。。。");
    
    if ([query_type integerValue] == 0) {
        [self.allData removeAllObjects];
        [self requestMyOrderList];
    }else if ([query_type integerValue] == 1) {
        [self.doingData removeAllObjects];
        [self requestMyOrderList];
    }else if ([query_type integerValue] == 2) {
        [self.waitCommentData removeAllObjects];
        [self requestMyOrderList];
    }else if ([query_type integerValue] == 3) {
        [self.finishData removeAllObjects];
        [self requestMyOrderList];
    }
}

//TODO: - 创建4个tableView
-(void)_initContentView
{
    //tab
    NSArray *items = [NSArray arrayWithObjects:LocStr(@"全部"),LocStr(@"进行中"),LocStr(@"待评价"),LocStr(@"已完成"), nil];
    radio = [[UIRadioControl alloc] initWithFrame:CGRectMake(0,0,mScreenWidth,42) items:items];
    radio.selectedIndex = 0;
    
    _selectIdx = 0;  // 默认选中的是全部
    lasteSelectIndex = 0;// 默认上次选中的ID
    query_type = @"0";
    
    [radio addTarget:self action:@selector(radioValueChanged:) forControlEvents:UIControlEventTouchUpInside];
    [radio setTitleColor:MainFontColor forState:UIControlStateNormal];
    [radio setFont:UIFONT(14)];
    [self.view addSubview:radio];
    
    itemWidth = mScreenWidth/4;
    _radioBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, radio.bottom-2, mScreenWidth/items.count-(itemWidth/2), 2)];
    _radioBottomImageView.image = [[UIImage imageNamed:@"red_line@2x.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    [self.view addSubview:_radioBottomImageView];
    
    // 表视图有关
    _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, radio.bottom+8, mScreenWidth, mScreenHeight-64-radio.height+8)];
    _horizontalScrollView.contentSize = CGSizeMake(_horizontalScrollView.width*items.count, _horizontalScrollView.height);
    _horizontalScrollView.delegate = self;
    _horizontalScrollView.pagingEnabled = YES;
    _horizontalScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_horizontalScrollView];
    
    _identify = @"MyCustomListCell";
    /*TODO:全部*/
    self.allTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, _horizontalScrollView.height)];
    [self.allTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.allTableView setBackgroundColor:[UIColor clearColor]];
    self.allTableView.showsVerticalScrollIndicator = NO;
    [self.allTableView setBackgroundView:nil];
    [self.allTableView setDataSource:self];
    [self.allTableView setDelegate:self];
    self.allTableView.tag = 400;
    self.allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    /*空载页*/
    emptyBgView_1 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0, self.allTableView.width, self.allTableView.height)];
    emptyBgView_1.tipsString=@"哦噢,还没有任何订单信息~";
    emptyBgView_1.hidden = YES;
    [self.allTableView addSubview:emptyBgView_1];
    
    [_horizontalScrollView addSubview:self.allTableView];
     [self.allTableView registerNib:[UINib nibWithNibName:@"MyCustomListCell" bundle:nil] forCellReuseIdentifier:_identify];
    [self.allTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.allTableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    /*TODO:进行中*/
    self.doingCostTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth, 0, mScreenWidth, _horizontalScrollView.height)];
    [self.doingCostTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.doingCostTableView setBackgroundColor:[UIColor clearColor]];
    self.doingCostTableView.showsVerticalScrollIndicator = NO;
    [self.doingCostTableView setBackgroundView:nil];
    [self.doingCostTableView setDataSource:self];
    [self.doingCostTableView setDelegate:self];
    self.doingCostTableView.tag = 401;
    /*空载页*/
    emptyBgView_2 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0, self.doingCostTableView.width, self.doingCostTableView.height)];
    emptyBgView_2.tipsString=@"哦噢,还没有任何进行中的订单~";
    emptyBgView_2.hidden = YES;
    [self.doingCostTableView addSubview:emptyBgView_2];
    
    self.doingCostTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_horizontalScrollView addSubview:self.doingCostTableView];
     [self.doingCostTableView registerNib:[UINib nibWithNibName:@"MyCustomListCell" bundle:nil] forCellReuseIdentifier:_identify];
    [self.doingCostTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.doingCostTableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    /*TODO:待评价*/
    self.waitCommentTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth*2, 0, mScreenWidth, _horizontalScrollView.height)];
    [self.waitCommentTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.waitCommentTableView setBackgroundColor:[UIColor clearColor]];
    self.waitCommentTableView.showsVerticalScrollIndicator = NO;
    [self.waitCommentTableView setBackgroundView:nil];
    [self.waitCommentTableView setDataSource:self];
    [self.waitCommentTableView setDelegate:self];
    self.waitCommentTableView.tag = 402;
    self.waitCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    emptyBgView_3 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0, self.waitCommentTableView.width, self.waitCommentTableView.height)];
    emptyBgView_3.tipsString=@"哦噢,还没有任何待评价的订单~";
    emptyBgView_3.hidden = YES;
    [self.waitCommentTableView addSubview:emptyBgView_3];
    
    [_horizontalScrollView addSubview:self.waitCommentTableView];
    [self.waitCommentTableView registerNib:[UINib nibWithNibName:@"MyCustomListCell" bundle:nil] forCellReuseIdentifier:_identify];
    [self.waitCommentTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.waitCommentTableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    //已完成
    self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(mScreenWidth*3, 0, mScreenWidth, _horizontalScrollView.height)];
    [self.finishTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.finishTableView setBackgroundColor:[UIColor clearColor]];
    self.finishTableView.showsVerticalScrollIndicator = NO;
    [self.finishTableView setBackgroundView:nil];
    [self.finishTableView setDataSource:self];
    [self.finishTableView setDelegate:self];
    self.finishTableView.tag = 403;
    emptyBgView_4 = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0,self.finishTableView.width, self.finishTableView.height)];
    emptyBgView_4.tipsString=@"哦噢,还没有任何已完成的订单~";
    emptyBgView_4.hidden = YES;
    [self.finishTableView addSubview:emptyBgView_4];
    
    self.finishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_horizontalScrollView addSubview:self.finishTableView];
    [self.finishTableView registerNib:[UINib nibWithNibName:@"MyCustomListCell" bundle:nil] forCellReuseIdentifier:_identify];
    [self.finishTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [self.finishTableView addFooterWithTarget:self action:@selector(loadMoreData)];

    [self requestMyOrderList];
}


//TODO:下拉刷新
- (void)refreshData
{
    page=1;
    if ([query_type integerValue] == 0) {  //全部
        [self.allData removeAllObjects];
        [self requestMyOrderList];
    }else if([query_type integerValue] == 1) {   //进行中
        [self.doingData removeAllObjects];
        [self requestMyOrderList];
    }else if([query_type integerValue] == 2){   //待评价
        [self.waitCommentData removeAllObjects];
        [self requestMyOrderList];
    }else if([query_type integerValue] == 3){   //已完成
        [self.finishData removeAllObjects];
        [self requestMyOrderList];
    }
}

//TODO:加载更多
- (void)loadMoreData
{
    page++;
    [self requestMyOrderList];
}



//TODO:数据请求---订单列表数据请求
- (void)requestMyOrderList{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MyOrderList" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:query_type forKey:@"SelectState"];  //query_type
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:@"10" forKey:@"PageSize"];
    NSLog(@"query_type = %@",query_type);
    NSLog(@"parameterDic = %@",parameterDic);
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            NSLog(@"MyOrderList = %@",jsonObject);
            
            [NSThread detachNewThreadSelector:@selector(setData:) toTarget:self withObject:jsonObject];
            [SVProgressHUD dismiss];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        [self endRefresh];
    }];
}


// 设置数据
- (void)setData:(NSDictionary *)aDict
{
    NSArray *items = [aDict objectForKey:@"data"];
    if(items){
        NSInteger count = items.count;
        for(int i=0;i<count;i++){
            if (_selectIdx == 0) {// 全部
               [self.allData addObject:[[MyOrderModel alloc] initWithDataDic:[items objectAtIndex:i]]];
            } else if(_selectIdx == 1) {// 进行中
               [self.doingData addObject:[[MyOrderModel alloc] initWithDataDic:[items objectAtIndex:i]]];
            } else if(_selectIdx == 2) {   //待评价
               [self.waitCommentData addObject:[[MyOrderModel alloc] initWithDataDic:[items objectAtIndex:i]]];
            } else if (_selectIdx == 3) {   //已完成
               [self.finishData addObject:[[MyOrderModel alloc] initWithDataDic:[items objectAtIndex:i]]];
            }

        }
    }
    
    [self performSelectorOnMainThread:@selector(updateUI) withObject:self waitUntilDone:NO];
}

// 刷新UI
- (void)updateUI
{
    if (_selectIdx == 0) {
        
        emptyBgView_1.hidden =_allData.count==0?NO:YES;
       
        [self.allTableView reloadData];
        [self.allTableView headerEndRefreshing];
        [self.allTableView footerEndRefreshing];
        
    }else if (_selectIdx == 1) {
        
        emptyBgView_2.hidden =_doingData.count==0?NO:YES;
        
        [self.doingCostTableView reloadData];
        [self.doingCostTableView headerEndRefreshing];
        [self.doingCostTableView footerEndRefreshing];
   
    }else if (_selectIdx == 2){
        
        emptyBgView_3.hidden =_waitCommentData.count==0?NO:YES;
        
        [self.waitCommentTableView reloadData];
        [self.waitCommentTableView headerEndRefreshing];
        [self.waitCommentTableView footerEndRefreshing];
   
    }else if(_selectIdx == 3) {
        
        emptyBgView_4.hidden =_finishData.count==0?NO:YES;
        
        [self.finishTableView reloadData];
        [self.finishTableView headerEndRefreshing];
        [self.finishTableView footerEndRefreshing];
        
    }
}


- (void)endRefresh {
    
    [self.finishTableView headerEndRefreshing];
    [self.finishTableView footerEndRefreshing];
    [self.waitCommentTableView headerEndRefreshing];
    [self.waitCommentTableView footerEndRefreshing];
    [self.doingCostTableView headerEndRefreshing];
    [self.doingCostTableView footerEndRefreshing];
    [self.allTableView headerEndRefreshing];
    [self.allTableView footerEndRefreshing];
}



//TODO:UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([query_type integerValue] == 0) {
        return self.allData.count;
    }else if ([query_type integerValue] == 1) {
        return self.doingData.count;
    }else if ([query_type integerValue] == 2){
        return self.waitCommentData.count;

    }else if ([query_type integerValue] == 3) {
        return self.finishData.count;
    }
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyCustomListCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor= [UIColor redColor];
    cell.backgroundColor = RGBA(246, 247, 248, 1);
    
    
    if (tableView.tag == 400) {
        
        if (self.allData.count > 0) {
           [cell setMyOrderModel:self.allData[indexPath.row]];
        }
        
    }else if (tableView.tag == 401) {
        
        if (self.doingData.count > 0) {
          [cell setMyOrderModel:self.doingData[indexPath.row]];
        }
        
    }else if (tableView.tag == 402){
        
        if (self.waitCommentData.count > 0) {
            [cell setMyOrderModel:self.waitCommentData[indexPath.row]];
        }
        
    }else if (tableView.tag == 403) {
        
        if (self.finishData.count > 0) {
           [cell setMyOrderModel:self.finishData[indexPath.row]];
        }
        
    }
    
    
    return cell;
}


#pragma mark --- 跳到订单详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转到详情
    MyOrderModel *mod;
    switch (tableView.tag) {
        case 400:
        {
            if(self.allData.count > 0)
            {
              mod = self.allData[indexPath.row];
            }
            
        }
            break;
        case 401:
        {
            if(self.doingData.count > 0)
            {
               mod = self.doingData[indexPath.row];
            }
            
        }
            break;
        case 402:
        {
            if(self.waitCommentData.count > 0)
            {
                mod = self.waitCommentData[indexPath.row];
            }
           
        }
            break;
        case 403:
        {
            if(self.finishData.count > 0)
            {
               mod = self.finishData[indexPath.row];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    MyOrderDetailVC *orderDetailVC = [[MyOrderDetailVC alloc]initWithOrderCode:mod.OrderCode FormType:@"1"];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    MyOrderModel *myOrderModel;
    if ([query_type integerValue] == 0) {

        if(self.allData.count>0)
        {
           myOrderModel = self.allData[indexPath.row];
        }
        
    }else if ([query_type integerValue] == 1) {

        if(self.doingData.count>0)
        {
           myOrderModel = self.doingData[indexPath.row];
        }
 
    }else if ([query_type integerValue] == 2) {
        
        if(self.waitCommentData.count>0)
        {
            myOrderModel = self.waitCommentData[indexPath.row];
        }
        
    }else if ([query_type integerValue] == 3) {
    
        if(self.finishData.count > 0)
        {
           myOrderModel = self.finishData[indexPath.row];
        }
    }
    switch ([myOrderModel.OrderState integerValue]) {
        case 1:
            return 255;
            break;
        case 6:
            return 255;
            break;
        case 7:
            return 255;
            break;
        case 8:
            return 255;
            break;
            
        default:
            return 210;
            break;
    }
}



//TODO:数据请求---修改订单状态
- (void)requestOrderChange:(NSString *)orderType {
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ChangeOrderState" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:orderType forKey:@"OrderType"];  //修改订单的操作   1-- 取消订单   2--- 确认收货
    [parameterDic setValue:orderCode_1 forKey:@"OrderCode"];  //订单编号  从订单列表返回的订单编号
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            if ([query_type integerValue] == 0) {
                if (self.allData.count > 0) {
                    [self.allData removeAllObjects];
                }
            }else if ([query_type integerValue] == 1) {
                if (self.doingData.count > 0) {
                    [self.doingData removeAllObjects];
                }
            }else if ([query_type integerValue] == 2) {
                if (self.waitCommentData.count > 0) {
                    [self.waitCommentData removeAllObjects];
                }
            }else if ([query_type integerValue] == 3) {
                if (self.finishData.count > 0) {
                    [self.finishData removeAllObjects];
                }
            }
            [self requestMyOrderList];
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        
    }];
}



//TODO:  UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //左右滑动时下面的imgView跟着滑动
    if (scrollView == _horizontalScrollView) {
        int x = scrollView.contentOffset.x;
        _radioBottomImageView.left = x/mScreenWidth*mScreenWidth/4+(itemWidth/4);
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _horizontalScrollView) {
        
        int x = scrollView.contentOffset.x;
        _selectIdx = x/mScreenWidth;
        if (lasteSelectIndex != _selectIdx) {
            radio.selectedIndex = _selectIdx;
            query_type = [self getQuery_type:_selectIdx];
            switch (_selectIdx) {
                case 0:{
                    if (self.allData.count == 0) {
                        [self requestMyOrderList];
                    }else {
                    }
                }
                    break;
                case 1:{
                    if (self.doingData.count == 0) {
                      [self requestMyOrderList];
                    }else {
                    }
                }
                    break;
                case 2:{
                    if (self.waitCommentData.count == 0) {
                        [self requestMyOrderList];
                    }else {
                    }
                }
                    break;
                case 3: {
                    if (self.finishData.count == 0) {
                        [self requestMyOrderList];
                    }else {
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            
        }
        lasteSelectIndex = _selectIdx;
        
    }
    
    NSLog(@"%@",query_type);
}

/*改变radio的标题*/
- (void)radioValueChanged:(UIRadioControl *)sender
{
    _selectIdx = (int)sender.selectedIndex;
    
    if (lasteSelectIndex != _selectIdx) {
        _radioBottomImageView.left = mScreenWidth/4*sender.selectedIndex;
        [_horizontalScrollView setContentOffset:CGPointMake(_horizontalScrollView.width*_selectIdx, 0) animated:YES];
        query_type = [self getQuery_type:_selectIdx];
        switch (_selectIdx) {
            case 0:{
                if (self.allData.count == 0) {
                    [self requestMyOrderList];
                }else {
                }
            }
                break;
            case 1:{
                if (self.doingData.count == 0) {
                     [self requestMyOrderList];
                }else {
                }
            }
                break;
            case 2:{
                if (self.waitCommentData.count == 0) {
                     [self requestMyOrderList];
                }else {
                }
            }
                break;
            case 3: {
                if (self.finishData.count == 0) {
                     [self requestMyOrderList];
                }else {
                }
            }
                break;
                
            default:
                break;
        }
    }else{
        
    }
    lasteSelectIndex = _selectIdx;
}


-(NSString *)getQuery_type:(int)selected
{
    switch (_selectIdx) {
        case 0:
            return @"0";
            break;
        case 1:
            return @"1";
            break;
        case 2:
            return @"2";
            break;
        case 3:
            return @"3";
            break;
        default:
            return @"0";
            break;
    }
}


#pragma mark-- 监听通知  第一个按钮
- (void)OrderAActionNotification:(NSNotification *)notification
{
     NSDictionary *dic = notification.userInfo;
     NSString *orderStatus =  dic[@"orderStatus"]; //订单状态
     orderCode_1 =  dic[@"orderCode"]; //订单ID

    switch ([orderStatus integerValue])
    {
        case 1:{    //待支付 --> 去支付
            
            ChoosePayTypeVC *payVC  = [[ChoosePayTypeVC alloc]init];
            payVC.orderCode = orderCode_1;
            payVC.InviteFriend = dic[@"InviteFriend"];
            payVC.OrderShare = dic[@"OrderShare"];
            payVC.IFReturn = dic[@"IFReturn"];
            payVC.SJCoupon = dic[@"SJCoupon"];
            payVC.Amount = dic[@"orderPrice"];
            [self.navigationController pushViewController:payVC animated:YES];
            
        }
            break;
        case 6:
        {      //已发货 --> 确认收货
            
            [self sureAlterView];
        }
            break;
        default:
            break;
    }
   
}
#pragma mark-- 监听通知  第二个按钮
- (void)OrderBActionNotification:(NSNotification *)notification
{
    
    NSString *orderStatus =  notification.userInfo[@"orderStatus"];
    orderCode_1 =  notification.userInfo[@"orderCode"];  //修改订单状态需要传订单编号
    
    switch ([orderStatus integerValue])
    {
        case 1:
        {    //待支付  --> 取消订单
            
            [self cancelOrderAction:nil];
        }
            break;
        case 6:
        {    //已发货 --> 查看物流
            
            LogisticsInfoVC *logisticInfo =  [[LogisticsInfoVC alloc] initWithOrderId:orderCode_1];
            logisticInfo.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:logisticInfo animated:YES];

        }
            break;
        case 7:
        {       //待评价 --> 去评价
            PublishCommentVC *next  = [[PublishCommentVC alloc]initWithCodeID:orderCode_1];
            [self.navigationController pushViewController:next animated:YES];
        }
            break;
        case 8:
        {      //已完成 --> 申请售后
            
            ApplyServiceVC *applyService =  [[ApplyServiceVC alloc] initWithorderID:orderCode_1];
            applyService.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:applyService animated:YES];
        }
            break;
        default:
            break;
    }

}

#pragma mark -- 提示框及处理事件
/*确认订单跳出的确认提示框*/
- (void)sureAlterView
{
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确认收货"
                                                        message:@"确定确认收货"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alterView.tag = 601;
    [alterView show];
}


/*TODO:取消订单跳出的确认提示框  取消订单别忘了释放库存*/
- (void)cancelOrderAction:(UIButton *)button
{
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"取消订单"
                               message:@"确定取消订单"
                              delegate:self
                     cancelButtonTitle:@"取消"
                     otherButtonTitles:@"确定", nil];
    alterView.tag = 600;
    [alterView show];
}

/*提示框点击事件*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //取消订单
    if (alertView.tag == 600) {
        if (buttonIndex == 1) {
            [self requestOrderChange:@"1"];
        }else {
            
        }
    }else {    //确认收货
        if (buttonIndex == 1) {
            [self requestOrderChange:@"4"];
        }else {
            
        }
    }
}

@end
