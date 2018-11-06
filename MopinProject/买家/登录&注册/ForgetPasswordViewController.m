//
//  ForgetPasswordViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "Utility.h"
#import "NSTimer+ZKFBlock.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
{
    int _interval;
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"找回密码";
    [self setNavBackBtnWithType:1];
    
    _phoneTextField.inputAccessoryView=self.keyBordtoolBar;
    _codeTextField.inputAccessoryView=self.keyBordtoolBar;
    
}
- (void)backBtnClick
{
    [_timer invalidate];
    [super backBtnClick];
}
- (IBAction)codeBtnClick:(id)sender {
    
    if(![self phoneNumberIsRight:_phoneTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"CommonSendVCode" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:@"2" forKey:@"Type"];
    [parameterDic setValue:_phoneTextField.text forKey:@"Phone"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            _codeBtn.enabled=NO;
            CGRect frame=_codeBtn.frame;
            frame.origin.x=frame.origin.x-15;
            frame.size.width=frame.size.width+15;
            _codeBtn.frame=frame;
            [_codeBtn setTitle:@"重新获取(60s)" forState:UIControlStateNormal];
            _interval=60;
//            _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeReduce:) userInfo:nil repeats:YES];
            
            __weak typeof(self) weakSelf=self;
            _timer=[NSTimer ZKF_scheduledTimerWithTimeInterval:1.0 block:^{
                [weakSelf timeReduce];
            } repeats:YES];
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
        NSLog(@"%@",error);
        
    }];
}
//TODO:倒计时
-(void)timeReduce
{
    _interval--;
    [_codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ds)",_interval] forState:UIControlStateNormal];
    if(_interval==0){
        _codeBtn.enabled=YES;
        CGRect frame=_codeBtn.frame;
        frame.origin.x=frame.origin.x+10;
        frame.size.width=frame.size.width-10;
        _codeBtn.frame=frame;
        
        _timer.fireDate=[NSDate distantFuture];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

//TODO:判断电话号码是11位且为1开头的数字
-(BOOL)phoneNumberIsRight:(NSString *)str{
    if(str.length==11 && [str characterAtIndex:0]=='1'){
        for(int i=1;i<11;i++){
            if([str characterAtIndex:i]<'0' || [str characterAtIndex:i]>'9'){
                return NO;
            }
        }
        return YES;
    }
    return NO;
}
- (IBAction)sureBtnClick:(id)sender {
    if(![self phoneNumberIsRight:_phoneTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if(_codeTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if(_passwordTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if(_passwordTextField.text.length<6 || _passwordTextField.text.length>16){
        [SVProgressHUD showErrorWithStatus:@"密码为6-16位"];
        return;
    }
    if(![_passwordTextField.text isEqualToString:_repeatPasswordTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        return;
    }
    _sureBtn.userInteractionEnabled=NO;
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"FindPassword" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[Utility md5:_passwordTextField.text] forKey:@"Password"];
    [parameterDic setValue:_phoneTextField.text forKey:@"Phone"];
    [parameterDic setValue:_codeTextField.text forKey:@"VCode"];
    
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _sureBtn.userInteractionEnabled=YES;
        
        if (code.integerValue == 1000) {
            
            [SVProgressHUD showSuccessWithStatus:@"密码修改成功"];
            [self backBtnClick];
        }
    } failure:^(NSError *error){
        _sureBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage=[UIImage imageNamed:@""];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:XiaoBiaoSong size:18]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
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
