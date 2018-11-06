//
//  OrderViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "OrderViewController.h"
#import "XHDHelper.h"
#import "orderListCell.h"
#import "SendOffMoPinViewController.h"
#import "ReplyCommentViewController.h"
#import "orderModel.h"
#import "WXBaseModel.h"
#import "selectStatusTableView.h"
#import "CommentListController.h"
#import "LogisticsInfoVC.h"
#import "MyOrderDetailVC.h"
#import "CustomChooseButton.h"
#import "CommonEmptyTableBgView.h"


@interface OrderViewController ()<UIGestureRecognizerDelegate>
{
    PersonalInfoSingleModel *_personalModel;
    UITableView *_tableView;
    NSString *_identify;
    UITableView *listTableView;
    CustomChooseButton *selectButton;
    NSString *selectID ;
    NSString *OrderCode;
    UIImageView *arrowImgView;
    UIView *maskView; //遮罩视图
    CommonEmptyTableBgView *emptyBgView; //空载页
}

@end


@implementation OrderViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _personalModel=[PersonalInfoSingleModel shareInstance];
        self.orderData = [NSMutableArray new];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _personalModel=[PersonalInfoSingleModel shareInstance];
         self.orderData = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusAction:)
                                                     name:@"statusPush"
                                                   object:nil];
    }
    return self;
}

//TODO:不同状态对应不同的处理方式
- (void)statusAction:(NSNotification *)notification {
    
    NSString *orderStatus = notification.userInfo[@"orderStatus"];
    OrderCode = notification.userInfo[@"OrderCode"];  //订单列表传过来的订单ID
    NSLog(@"orderStatus = %@",orderStatus);
    switch ([orderStatus integerValue]) {
        case 2:{   //确认创作
            [self requestOrderChange:@"2"];
        }
            break;
        case 3:{   //已寄墨品
            NSLog(@"2...");
            SendOffMoPinViewController *sendOffVC =  [[SendOffMoPinViewController alloc] initWithOrderID:OrderCode];
            sendOffVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sendOffVC animated:YES];
        }
            break;
        case 6:{  //查看进度
            NSLog(@"3...");
            LogisticsInfoVC *logisVC =  [[LogisticsInfoVC alloc] init];
            logisVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:logisVC animated:YES];
        }
            break;
            
        default:
            NSLog(@"haha..");
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title=@"订单管理";
    self.view.backgroundColor = RGBA(246, 247, 248, 1);

    
    [self createTableView];
    
    [self createNavRightButton];

    
    //监听改变下拉菜单的状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangelistStautsNotification:) name:@"ChangelistStautsNotification" object:nil];
    
    //已寄墨品返回刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderList:) name:@"updateOrderList" object:nil];
    
}

- (void)updateOrderList:(NSNotification *)notification {
    
    NSLog(@".......");
    if (self.orderData.count > 0) {
        [self.orderData removeAllObjects];
        
        if (selectID.length == 0) {
            [self requestOrderList:@"0"];
        }else {
            [self requestOrderList:selectID];
        }
    }else {
    }
}

//创建导航栏右边选择按钮
- (void)createNavRightButton {
    
    selectButton = [[CustomChooseButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    selectButton.titleStr = @"全部";
    [selectButton addTarget:self action:@selector(selecteStatusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
    UIBarButtonItem *place = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIToolbar *rightBar = [[UIToolbar alloc]initWithFrame:mRect(0, 0, 100, 40)];
    rightBar.barStyle = UIBarButtonItemStyleBordered;
    rightBar.barTintColor = [UIColor whiteColor];
    
    rightBar.items= @[place,rightButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBar];
    
    
    //弹出视图上的小三角
    arrowImgView = [[UIImageView alloc] initWithFrame:mRect(selectButton.width/2.0-20, selectButton.bottom-8, 30, 10)];
    arrowImgView.image = [UIImage imageNamed:@"icon_3(1).png"];
    arrowImgView.hidden = YES;
    [selectButton addSubview:arrowImgView];
}


//TODO:创建Tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, mScreenHeight - mTabBarHeight - mNavBarHeight+8) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    
    /*空载页*/
    emptyBgView = [[CommonEmptyTableBgView alloc]initWithFrame:mRect(0,0,_tableView.width, _tableView.height)];
    emptyBgView.tipsString=@"哦噢,还没有任何订单哦~";
    emptyBgView.hidden = NO;
    [_tableView addSubview:emptyBgView];
    
    [self.view addSubview:_tableView];
    
    _identify = @"orderListCell";
    [_tableView registerNib:[UINib nibWithNibName:@"orderListCell" bundle:nil] forCellReuseIdentifier:_identify];

    //首次进入：就传0 全部
    [self requestOrderList:@"0"];
    [_tableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_tableView addFooterWithTarget:self action:@selector(loadMoreData)];

}


//TODO:请求订单列表数据
- (void)requestOrderList:(NSString *)index {
    
    
    [SVProgressHUD show];
    NSLog(@"index = %@",index);
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"OrderManage" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:index forKey:@"SelectState"];  //0  --为全部
    
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(page)] forKey:@"PageIndex"];
    [parameterDic setValue:@"10" forKey:@"PageSize"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        NSArray *data = jsonObject[@"data"];
        if (code.integerValue == 1000) {
            
            NSLog(@"jsonObject = %@",jsonObject);
            [data enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL * stop) {
                
                orderModel *ordermodel = [[orderModel alloc] initWithDataDic:item];
                [self.orderData addObject:ordermodel];
                
            }];
            emptyBgView.hidden = self.orderData.count==0?NO:YES;
            [_tableView reloadData];
            [_tableView headerEndRefreshing];
            [_tableView footerEndRefreshing];
            NSLog(@"%@",self.orderData);
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
        NSLog(@"error = %@",error);
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
    }];
}



//TODO:数据请求---修改订单状态
- (void)requestOrderChange:(NSString *)orderType {
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ChangeOrderState" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[PersonalInfoSingleModel shareInstance].UserID forKey:@"UserID"];
    [parameterDic setValue:orderType forKey:@"OrderType"];  //修改订单的操作   1-- 取消订单   2--- 确认收货
    [parameterDic setValue:OrderCode forKey:@"OrderCode"];  //订单编号  从订单列表返回的订单编号
    NSLog(@"parameterDic = %@",parameterDic);
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            
            [self.orderData removeAllObjects];
            //判断状态--》请求数据
            if (selectID.length == 0) {
                
                [self requestOrderList:@"0"];
                
            }else{
                
                [self requestOrderList:selectID];
                
            }
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        [SVProgressHUD showErrorWithStatus:@"请求超时"];
        
    }];
}


//TODO:下拉刷新
- (void)refreshData
{
    page = 1;
    [self.orderData removeAllObjects];
    if (selectID.length == 0) {
        [self requestOrderList:@"0"];
    }else {
        [self requestOrderList:selectID];
    }
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}

//TODO:加载更多
- (void)loadMoreData
{
    page++;
    if (selectID.length == 0) {
        [self requestOrderList:@"0"];
    }else {
       [self requestOrderList:selectID];
    }
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.orderData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

       orderListCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
       if (self.orderData.count > 0){
           
           cell.orderModel = self.orderData[indexPath.row];
           
       }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 238;
}


//TODO:跳到订单管理详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //跳到订单管理详情
    if (self.orderData.count > 0) {
        orderModel *orderModel = self.orderData[indexPath.row];
        MyOrderDetailVC *orderDetailVC = [[MyOrderDetailVC alloc] initWithOrderCode:orderModel.OrderCode FormType:@"2"];
        orderDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}



#pragma mark - 按钮点击事件
- (void)selecteStatusAction:(CustomChooseButton *)button{
    
    button.selected = !button.selected;
    if (button.selected ==YES) {
        
        if(maskView == nil)
        {
            maskView = [[UIView alloc]initWithFrame:mRect(0, 0, kkDeviceWidth, kkDeviceHeight-64)];
            maskView.backgroundColor = [UIColor clearColor];
            maskView.maskView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeMaskView)];
            tap.delegate = self;
            [maskView addGestureRecognizer:tap];
            [self.view addSubview:maskView];
            
            if (listTableView == nil)
            {
                listTableView = [[selectStatusTableView alloc] initWithFrame:CGRectMake(mScreenWidth-20-100, 0, 100, 200)];
                [maskView addSubview:listTableView];
            }
            
        }
        arrowImgView.hidden = NO;
    }
    else{
        
        [self removeMaskView];
    }
    
}
/*移除视图*/
-(void)removeMaskView
{
    /*为什么remove后内存没有释放？*/
    [listTableView removeFromSuperview];
    [maskView removeFromSuperview];
    listTableView = nil;
    maskView = nil;
    
    arrowImgView.hidden = YES;
    selectButton.selected = NO;
}
/*解决手势冲突*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
    
}

#pragma mark -- 监听下拉菜单改变状态
- (void)ChangelistStautsNotification:(NSNotification*)notification {
    
    selectButton.titleStr = notification.userInfo[@"name"];
    selectButton.selected = NO;
   // selectID = notification.userInfo[@"selectID"];

    [self.orderData removeAllObjects];
    page = 1;
    //请求各自的数据
    [self requestOrderList:selectID];
    
    [self removeMaskView];
}



@end
