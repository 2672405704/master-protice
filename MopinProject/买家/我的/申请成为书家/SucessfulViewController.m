//
//  SucessfulViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "SucessfulViewController.h"

@interface SucessfulViewController ()

@property (weak, nonatomic) IBOutlet UIView *waitBgView;
@property (weak, nonatomic) IBOutlet UIView *sucessBgView;
@end

@implementation SucessfulViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=_navTitle;
    [self setNavBackBtnWithType:1];
    if(_type==2){
        _waitBgView.hidden=YES;
    }else{
        _sucessBgView.hidden=YES;
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self backBtnClick];
}
- (void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
