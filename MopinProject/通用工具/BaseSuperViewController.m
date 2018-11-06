//
//  BaseSuperViewController.m
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"


@interface BaseSuperViewController ()
@property (nonatomic,strong,readwrite) UIView *keyBordtoolBar; //在内部重新定义使其可变为读写
@end

@implementation BaseSuperViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;

    //IOS7 适配全屏显示
    if(IOS7_AND_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        //其中这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO
//        self.extendedLayoutIncludesOpaqueBars=NO;
    }
    self.view.backgroundColor=toPCcolor(@"#eeeeee");
    self.navigationController.navigationBar.translucent = YES; // 设置为透明

    //设置导航栏的标题的字体和颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:XiaoBiaoSong size:18]}];
}
//TODO:重写键盘确定按钮View的get方法
- (UIView *)keyBordtoolBar
{
    if(!_keyBordtoolBar)
    {
        UIView *toolBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, 44)];
        toolBar.backgroundColor=[UIColor whiteColor];
        [XHDHelper addDivLineWithFrame:mRect(0, 0, toolBar.width, 0.4) SuperView:toolBar];
         [XHDHelper addDivLineWithFrame:mRect(0, toolBar.height-0.4, toolBar.width, 0.4) SuperView:toolBar];
        
        UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [rightButton setTitleColor:THEMECOLOR_1 forState:UIControlStateNormal];
        rightButton.frame=CGRectMake(kkDeviceWidth-100, 0, 90, 44);
        [toolBar addSubview:rightButton];
        [rightButton addTarget:self action:@selector(rightkeyBordButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _keyBordtoolBar=toolBar;
    }
    return _keyBordtoolBar;
}
//TODO:点击键盘上的确定按钮 回收键盘
- (void)rightkeyBordButtonClick
{
    [self.view endEditing:YES];
}
//TODO:设置返回图片
- (void)setNavBackBtnWithType:(NSInteger)type
{
    // 显示图片
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0,11,12,22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if(type==1){
        [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }else{  //设置白色图片和白色颜色的文字
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:XiaoBiaoSong size:18]}];
        
//        [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"white_back.png"] forState:UIControlStateNormal];
    }
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 44, 44);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn addSubview:backBtn];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //右滑手势
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)setNavBackBtnWithTitle:(NSString *)title
{
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 44, 44);
    leftBtn.titleLabel.font=UIFONT(16);
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    //右滑手势
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
//TODO:点击返回
- (void)backBtnClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//TODO:设置右边图片
- (void)setRightNavImageIconWithFrame:(CGSize)size andImageStr:(NSString *)image
{
    // 显示图片
    UIButton *rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightImageBtn.frame = CGRectMake(44-size.width,(44-size.height)/2,size.width,size.height);
    [rightImageBtn addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightImageBtn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];

    _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame=CGRectMake(0, 0, 44, 44);
    [_rightBtn addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn addSubview:rightImageBtn];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    
    
}
//TODO:设置导航栏右边按钮文字
- (void)setRightNavTitleStr:(NSString *)string
{
    _rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame=CGRectMake(0, 0, 50, 60);
    [_rightBtn addTarget:self action:@selector(rightNavBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.titleLabel.font = UIFONT(16);
    _rightBtn.adjustsImageWhenDisabled = YES;
    [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightBtn setTitle:string forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
}
//TODO:隐藏右边按钮
- (void)hideRightBtn
{
    _rightBtn.hidden=YES;
}

- (void)rightNavBtnClick
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
