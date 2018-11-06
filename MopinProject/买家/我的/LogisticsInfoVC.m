//
//  LogisticsInfoVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/18.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "LogisticsInfoVC.h"
#import "XHDHelper.h"
#import "SearchProgressCell.h"
#import "LogisticsDetailVC.h"
#import "ProgressModel.h"


@interface LogisticsInfoVC () {
    UITableView *_tableView;
    UILabel *followLabel;
    NSMutableArray *dataArr; //数据源
    UILabel *stausLabel;//状态标题
    
}

@end

@implementation LogisticsInfoVC


- (instancetype)initWithOrderId:(NSString*)orderID
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        dataArr = [[NSMutableArray alloc]init];
        _orderID = orderID;
        [self requestProgressData];
    }
    return self;
}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"查看进度";
    [self setNavBackBtnWithType:1];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createTopView];
    
    [self createTableView];
    
    
    
}


//TODO:创建顶部视图
- (void)createTopView {
    
    UIView *statuesView = [[UIView alloc] initWithFrame:mRect(0, 0, mScreenWidth, 60)];
    [self.view addSubview:statuesView];
    
    
    stausLabel = [XHDHelper createLabelWithFrame:mRect(0, 0, mScreenWidth, 45) andText:@"     订单状态:" andFont:UIFONT(16) AndBackGround:RGBA(237, 238, 239, 1) AndTextColor:TitleFontColor];
    NSMutableAttributedString *mattrstring_charge = [[NSMutableAttributedString alloc] initWithString:stausLabel.text];
    [mattrstring_charge addAttribute:NSForegroundColorAttributeName
                               value:THEMECOLOR_1
                               range:NSMakeRange(10, mattrstring_charge.length-10)];
    stausLabel.attributedText = mattrstring_charge;
    [stausLabel adjustsFontSizeToFitWidth];
    [statuesView addSubview:stausLabel];
    
    followLabel = [XHDHelper createLabelWithFrame:mRect(0, stausLabel.bottom, mScreenWidth, 60) andText:@"     作品跟踪" andFont:UIFONT(16) AndBackGround:[UIColor whiteColor] AndTextColor:TitleFontColor];
    [statuesView addSubview:followLabel];
    
}



//TODO:创建Tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, followLabel.bottom, mScreenWidth, mScreenHeight - mTabBarHeight - mNavBarHeight+8) style:UITableViewStylePlain];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height  = 120;
    if(dataArr.count>0)
    {
        ProgressModel *mod = dataArr[indexPath.row];
        if([mod.Type isEqualToString:@"6"])
        {
           height =  140.0f;
        }
    }
    else
    {
        height = 120.0f;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchProgressCell *cell = [[SearchProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identify" tag:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(dataArr.count>0)
    {
        ProgressModel *mod = dataArr[indexPath.row];
        [cell _initUIWithMod:mod];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(dataArr.count>0)
    {
        ProgressModel *mod = dataArr[indexPath.row];
        if([mod.Type isEqualToString:@"6"])
        {
            LogisticsDetailVC *logisticsDetailVC = [[LogisticsDetailVC alloc] initWithDeliveryCode:mod.SendToMPCode DeliveryCompanyName:mod.CoName];
            logisticsDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:logisticsDetailVC animated:YES];
        }
    }
    
}


//TODO:去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -- 网络请求
- (void)requestProgressData
{
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetOrderPogress" forKey:@"Method"];
    [parameterDic setValue:_orderID forKey:@"OrderCode"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            for(NSDictionary *dic in jsonObject[@"data"])
            {
                //填充数据
                ProgressModel *mod = [[ProgressModel alloc]init];
                [mod setValuesForKeysWithDictionary:dic];
                [dataArr addObject:mod];
            }
            [_tableView reloadData];
            [self updateStatusLabe];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
/*更新标题栏*/
- (void)updateStatusLabe
{
    ProgressModel *mod = [dataArr lastObject];
    
    NSMutableAttributedString *mattrstring_charge = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"     订单状态：%@",[self getStatus:mod.Type]]];
    [mattrstring_charge addAttribute:NSForegroundColorAttributeName
                               value:THEMECOLOR_1
                               range:NSMakeRange(10, mattrstring_charge.length-10)];
    stausLabel.attributedText = mattrstring_charge;

}
/*根据状态码得到转态*/
-(NSString*)getStatus:(NSString*)str
{
    NSString *statusStr;
    NSInteger code = str.intValue;
    switch (code) {
        case 3:
            statusStr = @"作品创作中";
            break;
        case 4:
            statusStr = @"作品装裱中";
            break;
        case 5:
            statusStr = @"作品已装裱";
            break;
        case 6:
            statusStr = @"作品已发货";
            break;
            
        default:
            statusStr = @"";
            break;
    }
    return statusStr;
}

@end
