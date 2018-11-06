//
//  CertificationSignScucessViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/1.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CertificationSignScucessViewController.h"

@interface CertificationSignScucessViewController ()

@end

@implementation CertificationSignScucessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"签约认证";
    [self setNavBackBtnWithType:1];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self backBtnClick];
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
