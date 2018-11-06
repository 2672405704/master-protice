//
//  ApplyPenmanSucessViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/22.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ApplyPenmanSucessViewController.h"
#import "ApplyViewController.h"
#import "ExmapleWorkDetailVC.h"

@interface ApplyPenmanSucessViewController ()


@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@end

@implementation ApplyPenmanSucessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"发布成功";
    [self setNavBackBtnWithType:1];
    
    [_applyButton.titleLabel adjustsFontSizeToFitWidth];
}
- (void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)applyBtnClick:(id)sender {
    ApplyViewController *avc=[[ApplyViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)sampleDetailBtnClick:(id)sender {
    ExmapleWorkDetailVC *ewvc=[[ExmapleWorkDetailVC alloc]initWithArtID:_artID AndArtPrice:0 PMID:0];
    [self.navigationController pushViewController:ewvc animated:YES];
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
