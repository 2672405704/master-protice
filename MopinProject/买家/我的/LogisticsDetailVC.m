//
//  LogisticsDetailVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "LogisticsDetailVC.h"
#import "SearchProgressCell.h"
#import "ProgressModel.h"

@interface LogisticsDetailVC () {
    UITableView *_tableView;
    UILabel *followLabel;
    NSMutableArray *dataArr;  //数据源
}

@end

@implementation LogisticsDetailVC
-(instancetype)initWithDeliveryCode:(NSString*)code
                DeliveryCompanyName:(NSString*)name
{
   if(self=[super init])
   {
       _deliveryCode = code;
       _deliveryCompanyName = name;
       dataArr = [[NSMutableArray alloc]init];
       [self requestData];
       
   }
    return self;

}
#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"物流信息";
    [self setNavBackBtnWithType:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTopView];
    
    [self createTableView];
    
}


//TODO:创建顶部视图
- (void)createTopView {
    
    UIView *statuesView = [[UIView alloc] initWithFrame:mRect(0, 0, mScreenWidth, 60)];
    [self.view addSubview:statuesView];
    
    //RGBA(237, 238, 239, 1)
    UILabel *stausLabel = [XHDHelper createLabelWithFrame:mRect(0, 0,60, 45) andText:@"     物流单号:" andFont:UIFONT_Tilte(16) AndBackGround:RGBA(237, 238, 239, 1) AndTextColor:TitleFontColor];
    [statuesView addSubview:stausLabel];
    
    
    NSString *codeString = [NSString stringWithFormat:@"%@【%@】",_deliveryCode,_deliveryCompanyName];
    UILabel *stausLabel_1 = [XHDHelper createLabelWithFrame:mRect(stausLabel.right+4, 0,mScreenWidth-stausLabel.width-20, 45) andText:codeString andFont:UIFONT_Tilte(16) AndBackGround:RGBA(237, 238, 239, 1) AndTextColor:THEMECOLOR_1];
    [stausLabel_1 adjustsFontSizeToFitWidth];
    [statuesView addSubview:stausLabel_1];
    
    followLabel = [XHDHelper createLabelWithFrame:mRect(0, stausLabel.bottom, mScreenWidth, 60) andText:@"     物流跟踪" andFont:UIFONT_Tilte(16) AndBackGround:[UIColor whiteColor] AndTextColor:TitleFontColor];
    [statuesView addSubview:followLabel];
}



//TODO:创建Tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, followLabel.bottom, mScreenWidth, mScreenHeight - mNavBarHeight-105) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [self setExtraCellLineHidden:_tableView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataArr.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchProgressCell *cell = [[SearchProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify" tag:2];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(dataArr.count>0)
    {
        ProgressModel *mod = dataArr[indexPath.row];
        [cell _initDetailUIWithMod:mod];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LogisticsDetailVC *logisticsDetailVC = [[LogisticsDetailVC alloc] init];
    logisticsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:logisticsDetailVC animated:YES];
}


//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)requestData
{
    
#if 1  //正式
    
    NSString *codeID = @"27483d38f78f0098"; //固定授权编码
    NSString *showType = @"0";//返回Json格式
    NSString *str=  [NSString stringWithFormat:@"http://api.kuaidi100.com/api?id=%@&com=%@&nu=%@&v&show=%@&muti=1&order=desc",codeID,_deliveryCompanyName,_deliveryCode,showType];
    
#else  //测试
    
   NSString *str=@"http://api.kuaidi100.com/api?id=27483d38f78f0098&com=huitongkuaidi&nu=70366554080285&v&show=0&muti=1&order=desc";
    
#endif
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        for(NSDictionary *dic in responseObject[@"data"])
        {
            ProgressModel *mod = [[ProgressModel alloc]init];
            mod.Content = dic[@"context"];
            mod.Createtime = dic[@"time"];
            NSArray *arr = [mod.Content componentsSeparatedByString:@"|"];
            if(arr.count>1)
            {
                mod.Type = arr[1];
            }
            [dataArr addObject:mod];
        }
         [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}



@end
