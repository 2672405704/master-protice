//
//  MyTabBarController.m
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "MyTabBarController.h"

#import "SampleViewController.h"
#import "OrderViewController.h"
#import "TicketViewController.h"
#import "MyCalligrapherViewController.h"

#import "HomePageViewController.h"
#import "FundViewController.h"
#import "CollectionViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"

#import "ZKFCustomButton.h"
#import "AppDelegate.h"
@interface MyTabBarController ()
{
    NSArray *_imageArr;
    NSArray *_selectedImageArr;
    NSArray *_titleArr;
    NSInteger _selected;
    PersonalInfoSingleModel *_personalModel;
    NSMutableArray *_buttonArr;
}
@end

@implementation MyTabBarController

- (instancetype)initWithType:(NSInteger)type andSelectedIndex:(NSInteger)selectedIndex{
    self=[super init];
    if(self){
        _selected=selectedIndex;
        _personalModel=[PersonalInfoSingleModel shareInstance];
        
        [self createControllersWithType:type];
        [self createTabBar];
        
        AppDelegate *ap =(AppDelegate *)[UIApplication sharedApplication].delegate;
        ap.mtbc=self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
//TODO:创建视图
-(void)createControllersWithType:(NSInteger)type
{
    NSMutableArray *vcArr=[NSMutableArray array];
    if(type==1){
        _titleArr=@[@"首页",@"墨基金",@"收藏",@"我的"];
        _imageArr=@[@"tabbar_04.png",@"tabbar_01.png",@"tabbar_02.png",@"tabbar_03.png"];
        _selectedImageArr=@[@"tabbar_04_1.png",@"tabbar_01_1.png",@"tabbar_02_1.png",@"tabbar_03_1.png"];
        
        HomePageViewController *mpvc=[[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
        [vcArr addObject:mpvc];
        
        FundViewController *fvc=[[FundViewController alloc]initWithNibName:@"FundViewController" bundle:nil];
//        fvc.type=1;
        [vcArr addObject:fvc];
        
        CollectionViewController *cvc=[[CollectionViewController alloc]init];
        [vcArr addObject:cvc];
        
        MineViewController *mvc=[[MineViewController alloc]init];
        [vcArr addObject:mvc];
    
    }else{
        _titleArr=@[@"样品",@"订单",@"发券",@"我的"];
        _imageArr=@[@"tabbar_06.png",@"tabbar_05.png",@"tabbar_01.png",@"tabbar_03.png"];
        _selectedImageArr=@[@"tabbar_06_1.png",@"tabbar_05_1.png",@"tabbar_01_1.png",@"tabbar_03_1.png"];
        
        SampleViewController *svc=[[SampleViewController alloc]init];
        [vcArr addObject:svc];
        
        OrderViewController *ovc=[[OrderViewController alloc]init];
        [vcArr addObject:ovc];
        
        TicketViewController *tvc=[[TicketViewController alloc]init];
        [vcArr addObject:tvc];
        
        MyCalligrapherViewController *mcvc=[[MyCalligrapherViewController alloc]init];
        [vcArr addObject:mcvc];
    }
    NSMutableArray *ncArr=[NSMutableArray array];
    for(UIViewController *vc in vcArr){
        UINavigationController *mnc=[[UINavigationController alloc]initWithRootViewController:vc];
        [ncArr addObject:mnc];
    }
    self.viewControllers=ncArr;
}
//TODO:创建
- (void)createTabBar
{
    _buttonArr=[NSMutableArray array];
    CGFloat width=kkDeviceWidth/_titleArr.count;
    //批量生成4个按钮
    for(int i=0;i<_titleArr.count;i++){
        ZKFCustomButton *button=[ZKFCustomButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(width*i, 0, width, 49);
        button.titleLabel.textAlignment=NSTextAlignmentCenter;
        button.imageView.contentMode=UIViewContentModeCenter;
        [button setTitle:_titleArr[i] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:10];

        //阻止多点触摸
        button.exclusiveTouch=YES;
        button.tag=100+i;
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(-10,30, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(29, -20, 0, 0)];
        
        [button setImage:[UIImage imageNamed:_imageArr[i]] forState:UIControlStateNormal];
        [button setTitleColor:mRGBAColor(103, 104, 108, 1) forState:UIControlStateNormal];
        
        //设置选中
        [button setImage:[UIImage imageNamed:_selectedImageArr[i]] forState:UIControlStateSelected];
        [button setTitleColor:THEMECOLOR_1 forState:UIControlStateSelected];
        
//        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(kkDeviceWidth/8,24,1 , 1)];
//        line.backgroundColor=[UIColor redColor];
//        [button addSubview:line];
        //默认第一个按钮为选中状态
        if(i==_selected){
            button.selected=YES;
         }
         //给按钮添加点击事件
         [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
         //设置图片不变形
         button.imageView.contentMode= UIViewContentModeScaleAspectFit;
         //往tabbar上添加按钮
         [self.tabBar addSubview:button];
        
        [_buttonArr addObject:button];
    }
    self.selectedIndex=_selected;
}
- (void)buttonClick:(UIButton *)btn
{
    long index=btn.tag-100;
    if(!_personalModel.isLogin){
        if(index==2){
            LoginViewController *lvc=[[LoginViewController alloc]init];
            lvc.hidesBottomBarWhenPushed=YES;
            lvc.formVCTag=1;
            UINavigationController *nextNc=[[UINavigationController alloc]initWithRootViewController:lvc];
            
            UINavigationController *nc=self.viewControllers[self.selectedIndex];
            [nc.viewControllers[0] presentViewController:nextNc animated:YES completion:nil];
            return;
        }
    }
    
    self.selectedIndex=btn.tag-100;
    btn.selected=YES;
    
    
    for(int i=0;i<_titleArr.count;i++){
        if(i!=index){
            UIButton *notSelectedBtn=(UIButton *)[self.tabBar viewWithTag:100+i];
            notSelectedBtn.selected=NO;
        }
    }
}
- (void)selectedIndexClick:(NSInteger)index
{
    [self buttonClick:_buttonArr[index]];
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
