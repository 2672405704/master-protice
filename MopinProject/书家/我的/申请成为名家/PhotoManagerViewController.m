//
//  PhotoManagerViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "PhotoManagerViewController.h"

@interface PhotoManagerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation PhotoManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"图片管理";
    [self setNavBackBtnWithType:2];
    
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationController.navigationBar.shadowImage=[UIImage imageNamed:@""];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor=toPCcolor(@"262626");
    
    _imageView.contentMode=UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds=YES;
    
    _imageView.image=_image;
    
}
- (IBAction)deleteBtnClick:(id)sender {
    
    self.deletePhoto(_image);
    [self backBtnClick];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor=toPCcolor(@"ffffff");
    
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
