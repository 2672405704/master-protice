//
//  InputNameViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "InputNameViewController.h"
#import "PenmanMainInfoModel.h"

@interface InputNameViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView1;

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UITextField *penNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation InputNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"姓名/笔名";
    [self setNavBackBtnWithType:1];
    
    [self resetView];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
//TODO:设置View
- (void)resetView
{
    _bgView1.layer.cornerRadius=3;
    _bgView1.layer.masksToBounds=YES;
    
    _bgView2.layer.cornerRadius=3;
    _bgView2.layer.masksToBounds=YES;
    
    if(_model.TrueName.length!=0){
        _realNameTextField.text=_model.TrueName;
        _penNameTextField.text=_model.Penname;
    }
}
- (IBAction)sureBtnClick:(id)sender {
    if(_realNameTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请填写真实姓名"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_realNameTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"真实姓名不能全为空格"];
        return;
    }
    if(_penNameTextField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请填写常用笔名"];
        return;
    }
    if([DictionaryTool isValidateEmpty:_realNameTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"笔名不能全为空格"];
        return;
    }
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MainSaveName" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [parameterDic setValue:_penNameTextField.text forKey:@"Penname"];
    [parameterDic setValue:_realNameTextField.text forKey:@"TrueName"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            _model.TrueName=_realNameTextField.text;
            _model.Penname=_penNameTextField.text;
            self.inputName();
            [self backBtnClick];
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==_realNameTextField){
        [_penNameTextField becomeFirstResponder];
    }else{
        [_penNameTextField resignFirstResponder];
    }
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
