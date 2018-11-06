//
//  LoginViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/23.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "LoginViewController.h"
#import "Utility.h"
#import "Register1ViewController.h"
#import "ForgetPasswordViewController.h"
#import "MyTabBarController.h"
#import "ShareTools.h"
#import "JPUSHService.h"

@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *_phoneTextField;
    UITextField *_passwordTextField;
    UIButton *_loginBtn;
    UIImageView *_logoImageView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"墨品登录";
    [self setNavBackBtnWithType:2];
    [self createBgImage];
    [self createTextField];
    [self createButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
//TODO:监听键盘事件
- (void)keybordFrameChange:(NSNotification *)notification
{
    //获取键盘高度
    NSDictionary *info=[notification userInfo];
    //    CGFloat kbHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect kbframe=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval time=[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if(iPhone4){
        if(kbframe.origin.y!=kkDeviceHeight){
            [UIView animateWithDuration:time animations:^{
                self.view.frame=CGRectMake(0,kkDeviceHeight-CGRectGetMaxY(_passwordTextField.frame)-kbframe.size.height, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
                _logoImageView.transform=CGAffineTransformMakeScale(0,0);
            }];
        }else{
            [UIView animateWithDuration:time animations:^{
                self.view.frame=CGRectMake(0, 64, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
                _logoImageView.transform=CGAffineTransformMakeScale(1,1);
            }];
        }
        return;
    }
    if(kbframe.origin.y!=kkDeviceHeight){
        [UIView animateWithDuration:time animations:^{
            self.view.frame=CGRectMake(0,kkDeviceHeight-CGRectGetMaxY(_loginBtn.frame)-kbframe.size.height, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
            _logoImageView.transform=CGAffineTransformMakeScale(0,0);
        }];
    }else{
        [UIView animateWithDuration:time animations:^{
            self.view.frame=CGRectMake(0, 64, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
            _logoImageView.transform=CGAffineTransformMakeScale(1,1);
        }];
    }
}
- (void)createBgImage
{
    UIImageView *bgImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, -mNavBarHeight, kkDeviceWidth, kkDeviceHeight)];
    bgImageView.contentMode=UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds=YES;
    bgImageView.image=[UIImage imageNamed:@"login_bg.png"];
    [self.view addSubview:bgImageView];
    bgImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTap)];
    [bgImageView addGestureRecognizer:tap];
    
    if(iPhone4){
        _logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kkDeviceWidth-85)/2,(kkDeviceHeight-480)/2+0.03*kkDeviceHeight, 85, 130)];
    }else{
        _logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake((kkDeviceWidth-85)/2,(kkDeviceHeight-480)/2, 85, 130)];
    }
    _logoImageView.image=[UIImage imageNamed:@"logo.png"];
    [self.view addSubview:_logoImageView];
}
-(void)backBtnClick
{
    if(_formVCTag==1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [super backBtnClick];
    }
}
//TODO:点击背景
- (void)bgViewTap
{
    [self.view endEditing:YES];
}
//TODO:创建输入框
- (void)createTextField
{
    NSArray *leftImageArr=@[@"phone.png",@"lock.png"];
    NSArray *placeHolderTextArr=@[@"请输入手机号",@"密码"];
    CGFloat y;
    if(iPhone4){
        y=CGRectGetMaxY(_logoImageView.frame)+0.03*kkDeviceHeight;
    }else{
        y=CGRectGetMaxY(_logoImageView.frame)+0.06*kkDeviceHeight;
    }
    for(int i=0;i<2;i++){
        UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(40+30,y+50*i, kkDeviceWidth-80-30, 40)];
        textfield.textColor=[UIColor whiteColor];
        textfield.font=[UIFont boldSystemFontOfSize:16];
        textfield.placeholder=placeHolderTextArr[i];
        [textfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        textfield.delegate=self;
        
        if(i==0){
            UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40+8,y+11,13,18)];
            leftImageView.image=[UIImage imageNamed:leftImageArr[i]];
            [self.view addSubview:leftImageView];
        }else{
            UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40+8,y+10+50,14,21)];
            leftImageView.image=[UIImage imageNamed:leftImageArr[i]];
            [self.view addSubview:leftImageView];
        }
        
        UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40,y+40+i*50, kkDeviceWidth-80, 1)];
        lineImageView.image=[UIImage imageNamed:@"line.png"];
        [self.view addSubview:textfield];
        [self.view addSubview:lineImageView];
        if(i==0){
            textfield.keyboardType=UIKeyboardTypeNumberPad;
            _phoneTextField=textfield;
            _phoneTextField.inputAccessoryView=self.keyBordtoolBar;
        }else{
            textfield.secureTextEntry=YES;
            _passwordTextField=textfield;
        }
    }
}
//TODO:创建按钮
- (void)createButton
{
    NSArray *titleArr=@[@"找回密码",@"立即注册"];
    for(int i=0;i<2;i++){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(kkDeviceWidth-40-160+i*80, CGRectGetMaxY(_passwordTextField.frame), 80, 50);
//        button.backgroundColor=[UIColor blackColor];
        button.titleLabel.font=[UIFont systemFontOfSize:16];
        [button setTitleColor:toPCcolor(@"#888888") forState:UIControlStateNormal];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        if(i==0){
            button.titleEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
            [button addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
        }else{
            button.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
            [button addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(kkDeviceWidth-40-80, CGRectGetMaxY(_passwordTextField.frame)+19, 1,13)];
    lineLabel.backgroundColor=toPCcolor(@"#888888");
    [self.view addSubview:lineLabel];
    
    _loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame=CGRectMake(40, CGRectGetMaxY(_passwordTextField.frame)+70, kkDeviceWidth-80, 44);
    if(iPhone4){
        _loginBtn.frame=CGRectMake(40, CGRectGetMaxY(_passwordTextField.frame)+50, kkDeviceWidth-80, 44);
    }
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"login_bottom.png"] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [self.view addSubview:_loginBtn];
    
    NSArray *imageArr=@[@"qq.png",@"weibo.png",@"weixin.png"];
    NSArray *login_titleArr=@[@"QQ登录",@"微博登录",@"微信登录"];
    CGFloat width=50;
    CGFloat height=60;
    CGFloat space=(kkDeviceWidth-100-width*3)/2;
    for(int i=0;i<3;i++){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(50+(space+width)*i,(kkDeviceHeight+CGRectGetMaxY(_loginBtn.frame)-height-mNavBarHeight)/2, width, height);
        [button setTitle:login_titleArr[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
//        button.backgroundColor=[UIColor redColor];
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        button.titleEdgeInsets=UIEdgeInsetsMake(45, -40, 0, 0);
        button.imageEdgeInsets=UIEdgeInsetsMake(-15, 5, 0, 0);
        [button setTitleColor:toPCcolor(@"#eeeeee") forState:UIControlStateNormal];
        button.tag=100+i;
        [button addTarget:self action:@selector(loginWithThirdPlant:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}
//TODO:通过第三方平台登录
- (void)loginWithThirdPlant:(UIButton *)button
{
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    [SVProgressHUD show];
    
    if(button.tag==100){
        [ShareTools loginToThirdWithType:SSDKPlatformSubTypeQZone andSucess:^{
            
            MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
            [self presentViewController:mtbc animated:YES completion:^{
                WINDOW.rootViewController=mtbc;
                personalModel.openType=@"1";
                [self saveInfo];
            }];
        }];
    }else if(button.tag==101){
        [ShareTools loginToThirdWithType:SSDKPlatformTypeSinaWeibo andSucess:^{
            
            MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
            [self presentViewController:mtbc animated:YES completion:^{
                WINDOW.rootViewController=mtbc;
                personalModel.openType=@"2";
                [self saveInfo];
            }];
        }];
    }else{
        [ShareTools loginToThirdWithType:SSDKPlatformSubTypeWechatSession andSucess:^{
            
            MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
            [self presentViewController:mtbc animated:YES completion:^{
                WINDOW.rootViewController=mtbc;
                personalModel.openType=@"3";
                [self saveInfo];
            }];
        }];
    }
    
    [self.view endEditing:YES];
}
- (void)saveInfo
{
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
    [infoDic setValue:personalModel.openType forKey:@"openType"];
    [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
    [mUserDefaults synchronize];
}
//TODO:注册
- (void)registerBtnClick
{
    [self.view endEditing:YES];
    Register1ViewController *rvc=[[Register1ViewController alloc]init];
    [self.navigationController pushViewController:rvc animated:YES];
}
//TODO:忘记密码
- (void)forgetPassword
{
    [self.view endEditing:YES];
    ForgetPasswordViewController *fpvc=[[ForgetPasswordViewController alloc]initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:fpvc animated:YES];
}
//TODO:登录
- (void)loginBtnClick
{
    [self.view endEditing:YES];
    if(![self phoneNumberIsRight:_phoneTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if(_passwordTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    _loginBtn.userInteractionEnabled=NO;
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"UserLogin" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:[Utility md5:_passwordTextField.text] forKey:@"Password"];
    [parameterDic setValue:_phoneTextField.text forKey:@"Phone"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _loginBtn.userInteractionEnabled=YES;
        
        if (code.integerValue == 1000) {
            //保存ID
            NSDictionary *dic=jsonObject[@"data"];
            NSMutableDictionary *mutabDic=[NSMutableDictionary dictionaryWithDictionary:dic];
            [mutabDic setValue:@"1" forKey:@"type"];
            
            PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
            [personalModel setValuesForKeysWithDictionary:mutabDic];
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            
            [ud setValue:mutabDic forKey:@"PersonalInfo"];
            [ud setBool:YES forKey:@"Login"];
            [ud synchronize];
            
            
            if(_formVCTag == 1)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMineInfo object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCoupon object:nil];
            }else{
                
                MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
                [self presentViewController:mtbc animated:YES completion:^{
                    WINDOW.rootViewController=mtbc;
                }];
                
                [JPUSHService setTags:nil alias:personalModel.UserID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                    
                }];
            }
           
        }
    } failure:^(NSError *error){
        _loginBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
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
#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(iPhone4){
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame=CGRectMake(0,kkDeviceHeight-CGRectGetMaxY(_loginBtn.frame)+mNavBarHeight-310, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
//            _logoImageView.transform=CGAffineTransformMakeScale(0,0);
//        }];
//    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if(iPhone4){
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame=CGRectMake(0, 64, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
//            _logoImageView.transform=CGAffineTransformMakeScale(1,1);
//        }];
//    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.shadowImage=[[UIImage alloc]init];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:XiaoBiaoSong size:18]}];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
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
