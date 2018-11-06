//
//  SendOffMoPinViewController.m
//  MopinProject
//
//  Created by happyzt on 15/12/16.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SendOffMoPinViewController.h"
#import "XHDHelper.h"
#import "ExpressCompanyCell.h"
#import "QRCScannerViewController.h"
#import "UIImage+MDQRCode.h"
#import "QRCScanner.h"

@interface SendOffMoPinViewController ()<QRCodeScannerViewControllerDelegate> {
    UIView *_topView;
    UITableView *_tableView;
    UITextField *expressageNumber;
    UIControl *company;
    NSString *_identify;
    NSString *_orderID;
    NSString *_pressID;


}

@end

@implementation SendOffMoPinViewController

- (instancetype)initWithOrderID:(NSString *)orderID
{
    self = [super init];
    if (self) {
        _orderID = orderID;
        self.navigationItem.title=@"邮寄墨品";
        [self setNavBackBtnWithType:1];
        self.companyData = [NSMutableArray new];
        self.companyID = [NSMutableArray new];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createTopView];
    
    [self _createContentView];
    
    [self createTableView];
    
}


#pragma mark - 创建初始化视图
- (void)_createTopView {
    
    //加载xib文件
    _topView = [[[NSBundle mainBundle] loadNibNamed:@"topView" owner:nil options:nil] lastObject];
    _topView.frame = CGRectMake(0, 0, mScreenWidth, 100);
    [self.view addSubview:_topView];
}


- (void)_createContentView {
    
    //输入快递单号
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, _topView.bottom+5, mScreenWidth, 50)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textFieldView];
    
    CGRect textFrame = CGRectMake(30,5,mScreenWidth,40);
    expressageNumber = [[UITextField alloc] initWithFrame:textFrame];
    expressageNumber.font = [UIFont systemFontOfSize:15];
    expressageNumber.placeholder = @"请输入快递单号";
    [textFieldView addSubview:expressageNumber];
    expressageNumber.backgroundColor = [UIColor whiteColor];
    [expressageNumber setTintColor:[UIColor groupTableViewBackgroundColor]];
    [XHDHelper addToolBarOnInputFiled:expressageNumber Action:@selector(cancleFirst:) Target:self];
    
    UIImageView *twoDimension = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth-30-30, 10, 30, 30)];
    twoDimension.image = [UIImage imageNamed:@"Bar_code_767px_1156986_easyicon.net@2x.png"];
    [textFieldView addSubview:twoDimension];
    twoDimension.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scannerAction:)];
    [twoDimension addGestureRecognizer:tap];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(mScreenWidth-30-30, 20, 30, 2)];
    line.image = [UIImage imageNamed:@"nav_red_line@2x.png"];
    [textFieldView addSubview:line];
    
    //快递公司
    company = [[UIControl alloc] initWithFrame:CGRectMake(0,textFieldView.bottom+5, mScreenWidth, 50)];
    company.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:company];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 100, 50)];
    textLabel.text = @"快递公司";
    textLabel.font = [UIFont systemFontOfSize:15];
    [company addSubview:textLabel];
    
    //创建确认按钮
    UIButton *boomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    boomBtn.frame=CGRectMake(0, kkDeviceHeight-mTabBarHeight-mNavBarHeight, kkDeviceWidth,mTabBarHeight);
    boomBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [boomBtn setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    [boomBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [boomBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:boomBtn];

}



#pragma mark - 创建Tableview
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-2, company.bottom+1, mScreenWidth, mScreenHeight - 50 - mNavBarHeight-company.bottom) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _identify = @"ExpressCompanyCell";
    [_tableView registerNib:[UINib nibWithNibName:@"ExpressCompanyCell" bundle:nil] forCellReuseIdentifier:_identify];
    
    [self requestCompanyList];
    
    [self setExtraCellLineHidden:_tableView];

}

#pragma mark - 去除多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//TODO:请求加载快递公司
- (void)requestCompanyList {
    
    [SVProgressHUD show];
    
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetDeliveryCo" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            NSLog(@"%@",jsonObject);
            
            for (NSDictionary *dic in jsonObject[@"data"]) {
                NSString *CoName = dic[@"CoName"];
                [self.companyData addObject:CoName];
                [self.companyID addObject:dic[@"ID"]];
            }
        }
        [_tableView reloadData];
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        
    }];
}


#pragma mark -  UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.companyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpressCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    UILabel *companyLabel = (UILabel *)[cell viewWithTag:101];
    companyLabel.text = self.companyData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     _pressID = self.companyID[indexPath.row];
}


#pragma  mark - 按钮点击事件
// 添加单击手势隐藏键盘
-(void)cancleFirst:(UITapGestureRecognizer *)singleTap
{
    if ([expressageNumber isFirstResponder])
    {
        [expressageNumber resignFirstResponder];
    }
}


//TODO:确认已寄墨品
- (void)confirmAction:(UIButton *)button {
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SendToMP" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_orderID forKey:@"OrderCode"];   //订单ID  ---》从订单列表传过来
    [parameterDic setValue:_pressID forKey:@"DeliveryID"];  //快递公司ID ----》从获取快递公司接口的来
    [parameterDic setValue:expressageNumber.text forKey:@"SendToMPCode"];  //快递单号
    
    NSLog(@"parameterDic = %@",parameterDic);
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            NSLog(@"%@",jsonObject);
         
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOrderList"
                                                                object:nil
                                                              userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"error = %@",error);
        
    }];
    
}

//TODO:二维码扫描
- (void)scannerAction:(UIGestureRecognizer *)tap {
    NSLog(@"扫描。。。。。");
    QRCScannerViewController *VC = [[QRCScannerViewController alloc] init];
    VC.delegate = self;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 扫描二维码完成后的代理方法
- (void)didFinshedScanning:(NSString *)result{
    
    NSString *strUrl = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    expressageNumber.text = strUrl;
}





@end
