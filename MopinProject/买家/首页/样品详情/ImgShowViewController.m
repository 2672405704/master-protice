//
//  ImgShowViewController.m
//
//  图片展示控件
//
//  Created by Minr on 15-11-15.
//  Copyright (c) 2014年 XHD. All rights reserved.
//

#import "ImgShowViewController.h"
#import "MRImgShowView.h"

@interface ImgShowViewController ()
{
    MRImgShowView *imgShowView;
}

@end

@implementation ImgShowViewController

- (id)initWithSourceData:(NSMutableArray *)data withIndex:(NSInteger)index{
    
    self = [super init];
    if (self)
    {
       
        _data = data;
        _index = index;
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title=@"图片展示";
    [self setNavBackBtnWithType:1];
   // 设置导航栏为半透明
    self.navigationController.navigationBar.translucent = NO;
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    [self creatImgShow];
}

#pragma mark -- 图片展示视图
- (void)creatImgShow
{
    
    imgShowView = [[MRImgShowView alloc]
                                  initWithFrame:mRect(0,0, kkDeviceWidth, kkDeviceHeight)
                                    withSourceData:_data
                                    withIndex:_index];
    
    // 解决谦让
    [imgShowView requireDoubleGestureRecognizer:[[self.view gestureRecognizers] lastObject]];
    
    [self.view addSubview:imgShowView];
}

#pragma mark - 手势识别隐藏导航栏
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // 隐藏导航栏
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
       
        imgShowView.frame = mRect(0,self.navigationController.navigationBarHidden?0:-64, kkDeviceWidth,self.navigationController.navigationBarHidden?kkDeviceHeight:kkDeviceHeight-64);
    }];

}

#pragma mark - 返回
- (void)backBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

