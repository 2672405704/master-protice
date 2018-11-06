//
//  RunGridViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "RunGridViewController.h"
#import "PenmanMainInfoModel.h"

@interface RunGridViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation RunGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"平均润格";
    [self setNavBackBtnWithType:1];
    
    _bgView.layer.cornerRadius=3;
    _bgView.layer.masksToBounds=YES;
    if(_model.NPrice.length!=0){
        _textField.text=_model.NPrice;
    }
    _textField.inputAccessoryView=self.keyBordtoolBar;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)sureBtnClick:(id)sender {
    if(_textField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请填写您简介"];
        return;
    }
    if(![DictionaryTool isValidateNumber:_textField.text]){
        [SVProgressHUD showErrorWithStatus:@"润格必须为整数"];
        return;
    }
    
    [SVProgressHUD show];
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"MainSaveNPrice" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [parameterDic setValue:_textField.text forKey:@"NPrice"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            _model.NPrice=_textField.text;
            self.inputRunGrid();
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
