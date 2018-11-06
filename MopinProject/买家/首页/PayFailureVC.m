//
//  PayFailureVC.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "PayFailureVC.h"
#import "MyCustomListVC.h"
#import "ChoosePayTypeVC.h"

@interface PayFailureVC ()

@end

@implementation PayFailureVC
-(void)backBtnClick
{
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[ChoosePayTypeVC class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --  视图循环
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"支付失败";
    [self setNavBackBtnWithType:1];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeaderView];
}

#pragma mark -- 上面的视图
- (void)createHeaderView
{
    UIImageView * failImage = [XHDHelper createImageViewWithFrame:mRect(kkDeviceWidth*0.375+10, 35, kkDeviceWidth*0.25-20, kkDeviceWidth*0.25-20) AndImageName:@"plus_circle" AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:nil];
    [self.view addSubview:failImage];
    
    
    //很遗憾
    UILabel *bigTips = [XHDHelper createLabelWithFrame:mRect(kkDeviceWidth/4.0-20,failImage.bottom+12, kkDeviceWidth/2.0+40, 30) andText:@"很遗憾，支付失败了" andFont:UIFONT_Tilte(18) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
     bigTips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bigTips];
    
    //提示
    UILabel *smallTips = [XHDHelper createLabelWithFrame:mRect(bigTips.origin.x,bigTips.bottom+10, bigTips.width, 15) andText:@"您可以去我的定制中再次支付" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    smallTips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:smallTips];
    
    [self createMyCustomButtonWithFrame:mRect(25, smallTips.bottom+20, kkDeviceWidth-50, 45)];
}

#pragma mark -- 我的定制按钮
- (void)createMyCustomButtonWithFrame:(CGRect)frame
{
    UIButton *myBnt = [XHDHelper getRedGeneralButtonWithFrame:frame AndTitleString:@"我的定制"];
    myBnt.layer.cornerRadius = 3;
    myBnt.clipsToBounds = YES;
    [myBnt addTarget:self action:@selector(gotoMyCustom:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myBnt];
    
}
/*去我的定制*/
- (void)gotoMyCustom:(UIButton*)sender
{
    for(UIViewController *vc in self.navigationController.viewControllers)
    {
        if([vc isKindOfClass:[MyCustomListVC class]])
        {
           [self.navigationController popToViewController:vc animated:YES];
            return;
        }
       
    }
    MyCustomListVC *myList = [[MyCustomListVC alloc]init];
    [self.navigationController pushViewController:myList animated:YES];
    
    
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
