//
//  CompleteAccountViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CompleteAccountViewController.h"
#import "SucessfulViewController.h"
#import "ApplyModel.h"

@interface CompleteAccountViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@end

@implementation CompleteAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"完善账户信息";
    [self setNavBackBtnWithType:1];
    
    _bankNumTextField.inputAccessoryView=self.keyBordtoolBar;
    [self resetView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBordHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//TODO:键盘显示
- (void)keyBordShow:(NSNotification *)notification
{
    NSDictionary *info=[notification userInfo];
    double time=[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(iPhone4){
//        if([_bankNumTextField isFirstResponder]){
//            [UIView animateWithDuration:time animations:^{
//                self.view.frame=CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
//            }];
//            
//        }else{
//            [UIView animateWithDuration:time animations:^{
//                self.view.frame=CGRectMake(0, mNavBarHeight, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
//            }];
//            
//        }
        [UIView animateWithDuration:time animations:^{
            self.view.frame=CGRectMake(0, mNavBarHeight-20, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
        }];
    }
}
//TODO:键盘隐藏
- (void)keyBordHide:(NSNotification *)notification
{
    NSDictionary *info=[notification userInfo];
    double time=[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(iPhone4){
        [UIView animateWithDuration:time animations:^{
            self.view.frame=CGRectMake(0, mNavBarHeight, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
        }];
        
    }
}
- (void)resetView
{
    _bgView1.layer.cornerRadius=4;
    _bgView1.layer.masksToBounds=YES;
    
    _bgView2.layer.cornerRadius=4;
    _bgView2.layer.masksToBounds=YES;
    
    _bgView3.layer.cornerRadius=4;
    _bgView3.layer.masksToBounds=YES;
}
- (IBAction)confirmBtnClick:(id)sender {
    if(_bankNameTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入开户行"];
        return;
    }
    if(_bankNumTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入银行卡号"];
        return;
    }
    if(_nameTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_nameTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"持卡人姓名不能全为空格"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_bankNameTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"开户行不能全为空格"];
        return;
    }
//    SucessfulViewController *svc=[[SucessfulViewController alloc]init];
//    [self.navigationController pushViewController:svc animated:YES];
    
    [SVProgressHUD show];
    
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ApplyPenman" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:_applyModel.TrueName forKey:@"TrueName"];
    [parameterDic setValue:_applyModel.PenName forKey:@"PenName"];
    [parameterDic setValue:_applyModel.Email forKey:@"Email"];
    [parameterDic setValue:_applyModel.HJProviceID forKey:@"HJProviceID"];
    [parameterDic setValue:_applyModel.HJCityID forKey:@"HJCityID"];
    [parameterDic setValue:_applyModel.HJAreaID forKey:@"HJAreaID"];
    [parameterDic setValue:_applyModel.IDCardPic forKey:@"IDCardPic"];
    [parameterDic setValue:_applyModel.IDCard forKey:@"IDCard"];
    [parameterDic setValue:_bankNameTextField.text forKey:@"Bank"];
    [parameterDic setValue:_bankNumTextField.text forKey:@"Cardnumber"];
    [parameterDic setValue:_nameTextField.text forKey:@"AccountHolder"];
    
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            personalModel.UserType=@"1";
            personalModel.ApplyState=@"0";
            
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:personalModel.UserType forKey:@"UserType"];
            [infoDic setValue:personalModel.ApplyState forKey:@"ApplyState"];
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            
            SucessfulViewController *svc=[[SucessfulViewController alloc]init];
            svc.type=2;
            svc.navTitle=@"提交成功";
            [self.navigationController pushViewController:svc animated:YES];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}
#pragma mark - textFieldDelgate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
