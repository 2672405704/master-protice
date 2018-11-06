//
//  Register1ViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "Register1ViewController.h"
#import "Register2ViewController.h"
#import "NSTimer+ZKFBlock.h"

@interface Register1ViewController ()<UITextFieldDelegate>
{
    UIImageView *_logoImageView;
    UIButton *_codeBtn;
    UITextField *_phoneTextField;
    UITextField *_codeTextField;
    int _interval;
    NSTimer *_timer;
    UIButton *_nextButton;
}
@end

@implementation Register1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"用户注册";
    [self setNavBackBtnWithType:2];
    [self createBgImage];
    [self createTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
//TODO:计时器失效
- (void)stopTimer
{
    [_timer invalidate];
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
                self.view.frame=CGRectMake(0,kkDeviceHeight-CGRectGetMaxY(_codeTextField.frame)-kbframe.size.height, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
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
            self.view.frame=CGRectMake(0,kkDeviceHeight-CGRectGetMaxY(_nextButton.frame)-kbframe.size.height, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
            _logoImageView.transform=CGAffineTransformMakeScale(0,0);
        }];
    }else{
        [UIView animateWithDuration:time animations:^{
            self.view.frame=CGRectMake(0, 64, kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
            _logoImageView.transform=CGAffineTransformMakeScale(1,1);
        }];
    }
}
- (void)backBtnClick
{
    [self stopTimer];
    [super backBtnClick];
}
//TODO:点击背景
- (void)bgViewTap
{
    [self.view endEditing:YES];
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
- (void)createTextField
{
    NSArray *leftImageArr=@[@"phone.png",@"code_register.png"];
    NSArray *placeHolderTextArr=@[@"请输入手机号",@"验证码"];
    CGFloat y;
    if(iPhone4){
        y=CGRectGetMaxY(_logoImageView.frame)+0.05*kkDeviceHeight;
    }else{
        y=CGRectGetMaxY(_logoImageView.frame)+0.1*kkDeviceHeight;
    }
    for(int i=0;i<2;i++){
        UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(40+30,y+50*i, kkDeviceWidth-80-30, 40)];
        textfield.textColor=[UIColor whiteColor];
        textfield.font=[UIFont boldSystemFontOfSize:16];
        textfield.placeholder=placeHolderTextArr[i];
        [textfield setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        textfield.delegate=self;
        textfield.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
        if(i==0){
            UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40+8,y+11,13,18)];
            leftImageView.image=[UIImage imageNamed:leftImageArr[i]];
            [self.view addSubview:leftImageView];
        }else{
            UIImageView *leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40+7,y+12+50,17,17)];
            leftImageView.image=[UIImage imageNamed:leftImageArr[i]];
            [self.view addSubview:leftImageView];
        }
        
        UIImageView *lineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(40,y+40+i*50, kkDeviceWidth-80, 1)];
        lineImageView.image=[UIImage imageNamed:@"line.png"];
        [self.view addSubview:textfield];
        [self.view addSubview:lineImageView];
        textfield.inputAccessoryView=self.keyBordtoolBar;
        textfield.keyboardType=UIKeyboardTypeNumberPad;
        if(i==0){
            _phoneTextField=textfield;
        }else{
            textfield.frame=CGRectMake(40+30,y+50, kkDeviceWidth-80-30-100, 40);
            _codeTextField=textfield;
            _codeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            _codeBtn.frame=CGRectMake(kkDeviceWidth-40-100, y+50, 100, 30);
            [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            _codeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
            [_codeBtn setTitleColor:mRGBColor(187, 184, 186) forState:UIControlStateNormal];
            [_codeBtn setBackgroundImage:[UIImage imageNamed:@"get_code.png"] forState:UIControlStateNormal];
            [self.view addSubview:_codeBtn];
            
            [_codeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame=CGRectMake(40,(kkDeviceHeight+CGRectGetMaxY(_codeTextField.frame)-44-mNavBarHeight)/2, kkDeviceWidth-80, 44);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"login_bottom.png"] forState:UIControlStateNormal];
    nextBtn.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _nextButton=nextBtn;
    [self.view addSubview:nextBtn];
}
//TODO:获取验证码
- (void)getCode
{
    if(![self phoneNumberIsRight:_phoneTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"CommonSendVCode" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:@"1" forKey:@"Type"];
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
            
            __weak typeof(self) weakSelf=self;
            _timer=[NSTimer ZKF_scheduledTimerWithTimeInterval:1.0 block:^{
                [weakSelf timeReduce];
            } repeats:YES];
//            _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeReduce:) userInfo:nil repeats:YES];
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
//TODO:下一步
- (void)nextBtnClick
{
    [self.view endEditing:YES];
    if(![self phoneNumberIsRight:_phoneTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    if(_codeTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    [self checkVCode];
}
//TODO:验证验证码
- (void)checkVCode
{
    [SVProgressHUD show];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"CheckVCode" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_codeTextField.text forKey:@"VCode"];
    [parameterDic setValue:_phoneTextField.text forKey:@"Phone"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        if (code.integerValue == 1000) {
            Register2ViewController *rvc=[[Register2ViewController alloc]init];
            rvc.Phone=_phoneTextField.text;
            rvc.VCode=_codeTextField.text;
            [self.navigationController pushViewController:rvc animated:YES];
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
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
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if(iPhone4){
//        [UIView animateWithDuration:0.3 animations:^{
//            self.view.frame=CGRectMake(0,-120+(kkDeviceHeight>=667?0:kkDeviceHeight-667), kkDeviceWidth, kkDeviceHeight-mNavBarHeight);
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
