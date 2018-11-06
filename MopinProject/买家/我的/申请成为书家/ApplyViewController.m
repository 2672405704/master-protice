//
//  ApplyViewController.m
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ApplyViewController.h"
#import "CompleteInfoViewController.h"
#import "DDPageControl.h"
#import "SucessfulViewController.h"
#import "CertificationSignFailViewController.h"

static const CGFloat BottomButtonHeight=50;  //底部按钮高度
@interface ApplyViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    DDPageControl *_pageControl;
}
@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"为什么要成为墨品书家";
    [self setNavBackBtnWithType:1];
    [self createScrollView];
}
- (void)createScrollView
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-BottomButtonHeight)];
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.contentSize=CGSizeMake(kkDeviceWidth*4, kkDeviceHeight-mNavBarHeight-BottomButtonHeight);
    [self.view addSubview:_scrollView];
    
//    NSArray *titleArr=@[@[@"什么是墨品書家",@"能让所有爱好书法的人在这里",@"欣赏您的作品"],@[@"让欣赏您书法作品的墨客，能够轻",@"松的定制一件您的书法作品，从而",@"实现创作给您带来的价值"],@[@"填写更为详细个人资料和作品信息",@"将吸引更多的墨客来定制",@"您的书法作品"],@[@"在这里您可以轻松拥有一个",@"属于自己的圈子，与关注您的买家们",@"一起尽享书法带给你的乐趣"]];
    for(int i=0;i<4;i++){
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kkDeviceWidth*i, 0, kkDeviceWidth, kkDeviceHeight-mNavBarHeight-BottomButtonHeight)];
        NSString *imagePath=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"apply_bg_0%d@2x",i+1] ofType:@"png"];

        imageView.image=[UIImage imageWithContentsOfFile:imagePath];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        
//        for(int j=0;j<3;j++){
//            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, kkDeviceHeight-mNavBarHeight-190+j*24, kkDeviceWidth, 24)];
//            label.textColor=[UIColor whiteColor];
//            label.textAlignment=NSTextAlignmentCenter;
//            label.font=[UIFont boldSystemFontOfSize:19];
//            label.text=titleArr[i][j];
//            [imageView addSubview:label];
//        }
        
        [_scrollView addSubview:imageView];
    }
    _pageControl = [[DDPageControl alloc] init] ;
//    _pageControl.backgroundColor=[UIColor redColor];
    [_pageControl setCenter: CGPointMake(kkDeviceWidth/2, kkDeviceHeight-80-mNavBarHeight)] ;
    [_pageControl setNumberOfPages:4] ;
    [_pageControl setCurrentPage: 0] ;
    [_pageControl setDefersCurrentPageDisplay: NO] ;
    [_pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
    [_pageControl setOnColor: [UIColor colorWithWhite: 0.9f alpha: 1.0f]] ;
    [_pageControl setOffColor: [UIColor colorWithWhite: 0.7f alpha: 1.0f]] ;
    [_pageControl setIndicatorDiameter: 11.0f] ;
    [_pageControl setIndicatorSpace: 10.0f] ;
    [self.view addSubview: _pageControl] ;

    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"立即成为墨品书家" forState:UIControlStateNormal];
    button.frame=CGRectMake(0, kkDeviceHeight-50-mNavBarHeight, kkDeviceWidth, BottomButtonHeight);
    [button setBackgroundImage:[UIImage imageNamed:@"red_button_apply.png"] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:XiaoBiaoSong size:18];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

//TODO:立即成为书家
- (void)applyBtnClick
{
    PersonalInfoSingleModel *personalModel=[PersonalInfoSingleModel shareInstance];
    if(personalModel.UserType.intValue==1){
        if(personalModel.ApplyState.intValue==0){
            SucessfulViewController *svc=[[SucessfulViewController alloc]initWithNibName:@"SucessfulViewController" bundle:nil];
            svc.type=1;
            svc.navTitle=@"审核中";
            [self.navigationController pushViewController:svc animated:YES];
        }else if(personalModel.ApplyState.intValue==2){
            CertificationSignFailViewController *csvc=[[CertificationSignFailViewController alloc]initWithNibName:@"CertificationSignFailViewController" bundle:nil];
            csvc.type=3;
            [self.navigationController pushViewController:csvc animated:YES];
            
        }else{
            CompleteInfoViewController *cvc=[[CompleteInfoViewController alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];

        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%d",(int)(scrollView.contentOffset.x/kkDeviceWidth));
//    if(scrollView.contentOffset.x<kkDeviceWidth){
//        if(scrollView.contentOffset.x==0){
//            _pageControl.currentPage=scrollView.contentOffset.x/kkDeviceWidth;
//        }
//    }else{
        _pageControl.currentPage=scrollView.contentOffset.x/kkDeviceWidth;
//    }
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
