//
//  ChangeNicknameViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChangeNicknameViewController.h"

@interface ChangeNicknameViewController ()<UITextFieldDelegate>
{
    PersonalInfoSingleModel *_personalModel;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ChangeNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBackBtnWithType:1];
    self.navigationItem.title=@"修改昵称";
    _personalModel=[PersonalInfoSingleModel shareInstance];
    if(_personalModel.NickName.length!=0){
        _textField.text=_personalModel.NickName;
    }
    
    _bgView.layer.cornerRadius=3;
    _bgView.layer.masksToBounds=YES;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)sureBtnClick:(id)sender {
    if(![DictionaryTool isvalidateNickname:_textField.text]){
        [SVProgressHUD showErrorWithStatus:@"昵称只支持4-16个字符，中文、英文、数字和下划线"];
        return;
    }
    [SVProgressHUD show];
    _sureBtn.userInteractionEnabled=NO;
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SaveUserNickName" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:_textField.text forKey:@"NickName"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _sureBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            _personalModel.NickName=_textField.text;
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:_personalModel.NickName forKey:@"NickName"];
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            
            self.changeNickName();
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
