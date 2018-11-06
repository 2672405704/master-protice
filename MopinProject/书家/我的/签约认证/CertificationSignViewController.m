//
//  CertificationSignViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/1.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CertificationSignViewController.h"
#import "SucessfulViewController.h"

@interface CertificationSignViewController ()

@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation CertificationSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"签约认证";
    [self setNavBackBtnWithType:1];
}
- (IBAction)agreeBtnClick:(id)sender {
    if(_agreeBtn.selected){
        _agreeBtn.selected=NO;
    }else{
        _agreeBtn.selected=YES;
    }
}
- (IBAction)signBtnClick:(id)sender {
    if(!_agreeBtn.selected){
        [SVProgressHUD showErrorWithStatus:@"请先阅读并同意以上协议"];
        return;
    }
    
    [SVProgressHUD show];
    _signBtn.userInteractionEnabled=NO;
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"ApplyBookPenman" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    [parameterDic setValue:personalModel.UserID forKey:@"UserID"];
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        _signBtn.userInteractionEnabled=YES;
        if (code.integerValue == 1000) {
            personalModel.Sign=@"1";
            
            NSMutableDictionary *infoDic=[NSMutableDictionary dictionaryWithDictionary:[mUserDefaults objectForKey:@"PersonalInfo"]];
            [infoDic setValue:personalModel.Sign forKey:@"Sign"];
            [mUserDefaults setValue:infoDic forKey:@"PersonalInfo"];
            [mUserDefaults synchronize];
            SucessfulViewController *svc=[[SucessfulViewController alloc]initWithNibName:@"SucessfulViewController" bundle:nil];
            svc.type=2;
            svc.navTitle=@"签约认证";
            [self.navigationController pushViewController:svc animated:YES];
            
        }
    } failure:^(NSError *error){
        _signBtn.userInteractionEnabled=YES;
        
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
