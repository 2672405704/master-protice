//
//  ChangePhoneViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController ()
{
    int _interval;
    PersonalInfoSingleModel *_personalModel;
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"更换手机号";
    [self setNavBackBtnWithType:1];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    
    _bgView1.layer.cornerRadius=3;
    _bgView1.layer.masksToBounds=YES;
    
    _bgView2.layer.cornerRadius=3;
    _bgView2.layer.masksToBounds=YES;
    
    if(_personalModel.Phone.length!=0){
        [_phoneBtn setTitle:[NSString stringWithFormat:@"当前手机：%@",_personalModel.Phone] forState:UIControlStateNormal];
    }
    [self createToolBar];
}
//TODO:创建键盘上的按钮
- (void)createToolBar
{
    _phoneTextField.inputAccessoryView=self.keyBordtoolBar;
    _codeTextField.inputAccessoryView=self.keyBordtoolBar;
}
//TODO:键盘按钮
- (void)rightkeyBordButtonClick
{
    [self.view endEditing:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)backBtnClick
{
    [super backBtnClick];
    [_timer invalidate];
    
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
//            CGRect frame=_codeBtn.frame;
//            frame.origin.x=frame.origin.x-15;
//            frame.size.width=frame.size.width+15;
//            _codeBtn.frame=frame;
            [_codeBtn setTitle:@"重新获取(60s)" forState:UIControlStateNormal];
            _interval=60;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeReduce:) userInfo:nil repeats:YES];
        }
        
    } failure:^(NSError *error){
        
        [SVProgressHUD showErrorWithStatus:@"网络有问题哟，请检查网络是否连接~"];
        NSLog(@"%@",error);
        
    }];
}
//TODO:倒计时
-(void)timeReduce:(NSTimer *)timer
{
    _interval--;
    [_codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%ds)",_interval] forState:UIControlStateNormal];
    if(_interval==0){
        _codeBtn.enabled=YES;
//        CGRect frame=_codeBtn.frame;
//        frame.origin.x=frame.origin.x+10;
//        frame.size.width=frame.size.width-10;
//        _codeBtn.frame=frame;
        
        timer.fireDate=[NSDate distantFuture];
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
    
    [SVProgressHUD show];
    _sureBtn.userInteractionEnabled=NO;
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ChangePhone" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
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
            _personalModel.Phone=_phoneTextField.text;
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:_personalModel.Phone forKey:@"Phone"];
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            
            self.changePhone();
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
