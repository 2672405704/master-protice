//
//  CertificationSignFailViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/1.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CertificationSignFailViewController.h"
#import "DictionaryTool.h"

@interface CertificationSignFailViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@end

@implementation CertificationSignFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"签约认证";
    [self setNavBackBtnWithType:1];
}
- (void)setType:(NSInteger)type
{
    switch (type) {
        case 1:
            {
                self.navigationItem.title=@"签约认证";
                _tipsLabel.text=@"您暂未通过签约认证";
            }
            break;
        case 2:
            {
                self.navigationItem.title=@"申请成为书法名家";
                _tipsLabel.text=@"您暂未通过申请书法名家";
            }
            break;
        case 3:
            {
                self.navigationItem.title=@"申请成为书法家";
                _tipsLabel.text=@"您暂未通过申请书法家";
            }
            break;
        default:
            break;
    }
}
- (IBAction)contactServiceBtnClick:(id)sender {
    UIAlertView *al=[[UIAlertView alloc]initWithTitle:nil message:ServiceTel delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [al show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        return;
    }
    [[DictionaryTool shareDictionary] makeingACall:ServiceTel];
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
