//
//  SetStockViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/1.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SetStockViewController.h"

@interface SetStockViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation SetStockViewController
{
    PersonalInfoSingleModel *_personalModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"设置定制数";
    [self setNavBackBtnWithType:1];
    _personalModel=[PersonalInfoSingleModel shareInstance];
    _bgView.layer.cornerRadius=3;
    _bgView.layer.masksToBounds=YES;
    
    _textField.text=_personalModel.StockNum;
    _textField.inputAccessoryView=self.keyBordtoolBar;
}
- (IBAction)sureBtnClick:(id)sender {
    if(_textField.text.length==0){
        [SVProgressHUD showErrorWithStatus:@"请输入定制数"];
        return;
    }
    
    [SVProgressHUD show];
    _sureBtn.userInteractionEnabled=NO;
    
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"SetStock" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:_personalModel.UserID forKey:@"UserID"];
    [parameterDic setValue:_textField.text forKey:@"StockNum"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _sureBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            self.reloadCell(_textField.text);
            [self backBtnClick];
        }
    } failure:^(NSError *error){
        _sureBtn.userInteractionEnabled=YES;
        
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
