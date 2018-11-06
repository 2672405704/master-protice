//
//  Register2ViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "Register2ViewController.h"
#import "MyTabBarController.h"
#import "Utility.h"
#import "Register1ViewController.h"
#import "JPUSHService.h"

@interface Register2ViewController ()<UITextFieldDelegate>
{
    UIImageView *_logoImageView;
    UITextField *_nameTextField;
    UITextField *_passwordTextField;
    UITextField *_repeatPasswordTextField;
    UIButton *_resgisterBtn;
}
@end

@implementation Register2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"用户注册";
    [self setNavBackBtnWithType:2];
    [self createBgImage];
    [self createTextField];
    
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
                self.view.frame=CGRectMake(0,kkDeviceHeight-CGRectGetMaxY(_repeatPasswordTextField.frame)-kbframe.size.height, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
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
            self.view.frame=CGRectMake(0,kkDeviceHeight-CGRectGetMaxY(_resgisterBtn.frame)-kbframe.size.height, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
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
//TODO:点击背景
- (void)bgViewTap
{
    [self.view endEditing:YES];
}
//TODO:创建输入框
- (void)createTextField
{
    NSArray *leftImageArr=@[@"user_register.png",@"lock.png",@"lock.png"];
    NSArray *placeHolderTextArr=@[@"用户昵称",@"设置密码",@"再次输入"];
    CGFloat y;
    if(iPhone4){
        y=CGRectGetMaxY(_logoImageView.frame)+0.05*kkDeviceHeight;
    }else{
        y=CGRectGetMaxY(_logoImageView.frame)+0.1*kkDeviceHeight;
    }
    for(int i=0;i<3;i++){
        UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(40+30,y+50*i, kkDeviceWidth-80-30, 40)];
        textfield.textColor=[UIColor whiteColor];
        textfield.font=[UIFont boldSystemFontOfSize:16];
        textfield.placeholder=placeHolderTextArr[i];
        [textfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        textfield.delegate=self;
        
        if(i==0){
            UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40+8,y+11,18,19)];
            leftImageView.image=[UIImage imageNamed:leftImageArr[i]];
            [self.view addSubview:leftImageView];
        }else{
            UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40+8,y+10+50*i,14,21)];
            leftImageView.image=[UIImage imageNamed:leftImageArr[i]];
            [self.view addSubview:leftImageView];
        }
        
        UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40,y+40+i*50, kkDeviceWidth-80, 1)];
        lineImageView.image=[UIImage imageNamed:@"line.png"];
        [self.view addSubview:textfield];
        [self.view addSubview:lineImageView];
        if(i==0){
            _nameTextField=textfield;
        }else if(i==1){
            textfield.secureTextEntry=YES;
            _passwordTextField=textfield;
        }else{
            textfield.secureTextEntry=YES;
            _repeatPasswordTextField=textfield;
        }
    }
    _resgisterBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _resgisterBtn.frame=CGRectMake(40,(kkDeviceHeight+CGRectGetMaxY(_repeatPasswordTextField.frame)-44-mNavBarHeight)/2, kkDeviceWidth-80, 44);
    [_resgisterBtn setBackgroundImage:[UIImage imageNamed:@"login_bottom.png"] forState:UIControlStateNormal];
    _resgisterBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [_resgisterBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_resgisterBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:_resgisterBtn];
}
//TODO:点击注册
- (void)registerBtnClick
{
    [self.view endEditing:YES];
    if(_nameTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入昵称"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_nameTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"昵称不能全为空格"];
        return;
    }
    if(_passwordTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    if(_passwordTextField.text.length<6 && _passwordTextField.text.length>16){
        [SVProgressHUD showErrorWithStatus:@"密码为6-16位"];
        return;
    }
    if(![_passwordTextField.text isEqualToString:_repeatPasswordTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        return;
    }
    _resgisterBtn.userInteractionEnabled=NO;
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"UserRegister" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_nameTextField.text forKey:@"NickName"];
    [parameterDic setValue:[Utility md5:_passwordTextField.text] forKey:@"Password"];
    [parameterDic setValue:self.Phone forKey:@"Phone"];
    [parameterDic setValue:self.VCode forKey:@"VCode"];

    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _resgisterBtn.userInteractionEnabled=YES;
        
        if (code.integerValue == 1000) {
            //保存ID
            NSDictionary *dic=jsonObject[@"data"];
            NSMutableDictionary *mutabDic=[NSMutableDictionary dictionaryWithDictionary:dic];
            [mutabDic setValue:@"1" forKey:@"type"];
            [mutabDic setValue:_nameTextField.text forKey:@"NickName"];
            [mutabDic setValue:_Phone forKey:@"Phone"];
            [mutabDic setValue:@"1" forKey:@"UserType"];
            [mutabDic setValue:@"-1" forKey:@"ApplyState"];
            [mutabDic setValue:@"0" forKey:@"Sign"];
            
            PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
            [personalModel setValuesForKeysWithDictionary:mutabDic];
            
            NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
            
            [ud setValue:mutabDic forKey:@"PersonalInfo"];
            [ud setBool:YES forKey:@"Login"];
            [ud synchronize];
            
            NSInteger lastIndex=[self.navigationController.viewControllers indexOfObject:self.navigationController.viewControllers.lastObject];
            Register1ViewController *rvc=self.navigationController.viewControllers[lastIndex-1];
            [rvc stopTimer];
            
            MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
            [self presentViewController:mtbc animated:YES completion:^{
                WINDOW.rootViewController=mtbc;
            }];
            
            [JPUSHService setTags:nil alias:personalModel.UserID fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                
            }];
        }
    } failure:^(NSError *error){
        _resgisterBtn.userInteractionEnabled=YES;
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
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
//            self.view.frame=CGRectMake(0,-140+(kkDeviceHeight>=667?0:kkDeviceHeight-667), kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
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
