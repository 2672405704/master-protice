//
//  GiveCouponViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/3.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "GiveCouponViewController.h"
#import "NormalCouponModel.h"

@interface GiveCouponViewController ()
{
    NSInteger _price;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@end

@implementation GiveCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"常规券";
    [self setNavBackBtnWithType:1];
    
    [self resetView];
}
//TODO:设置View
- (void)resetView
{
    NSArray *titleArr=@[@"关注即送",@"分享给好友即送",@"首次成功定制即送"];
    _titleLabel.text=titleArr[_type-1];
    _mySwitch.on=_model.IsOpen.intValue;
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",_model.Amount];
    _price=_model.Amount.intValue;
    [self switchChange:_mySwitch];
}
//TODO:加
- (IBAction)rightBtnClick:(id)sender {
    _price+=50;
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",@(_price)];
}
//TODO:减
- (IBAction)leftBtnClick:(id)sender {
    if(_price==0){
        [SVProgressHUD showErrorWithStatus:@"不能再减少了"];
        return;
    }
    _price-=50;
    _priceLabel.text=[NSString stringWithFormat:@"￥%@",@(_price)];
}
//TODO:开关
- (IBAction)switchChange:(id)sender {
    UISwitch *swit=(UISwitch *)sender;
    if(swit.isOn){
        _priceLabel.textColor=toPCcolor(@"ca3b2b");
        _leftBtn.enabled=YES;
        _rightButton.enabled=YES;
    }else{
        _priceLabel.textColor=toPCcolor(@"cccccc");
        _rightButton.enabled=NO;
        _leftBtn.enabled=NO;
    }
}
//TODO:确定
- (IBAction)sureBtnClick:(id)sender {
    if(_mySwitch.isOn){
        if(_price==0){
            [SVProgressHUD showErrorWithStatus:@"金额不能为0"];
            return;
        }
    }
    _sureBtn.userInteractionEnabled=NO;
    
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"NormalCouponManage" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [parameterDic setValue:_model.Type forKey:@"Type"];
    [parameterDic setValue:[NSString stringWithFormat:@"%d",_mySwitch.isOn] forKey:@"IsOpen"];
    [parameterDic setValue:[NSString stringWithFormat:@"%@",@(_price)] forKey:@"Amount"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _sureBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            _model.IsOpen=[NSString stringWithFormat:@"%d",_mySwitch.isOn];
            _model.Amount=[NSString stringWithFormat:@"%@",@(_price)];
            
            self.resetNormalCoupon();
            [self backBtnClick];
        }
    } failure:^(NSError *error){
        _sureBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
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
