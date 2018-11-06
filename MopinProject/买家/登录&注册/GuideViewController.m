//
//  GuideViewController.m
//  MopinProject
//
//  Created by rt008 on 15/12/31.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "GuideViewController.h"
#import "MyTabBarController.h"

static const NSInteger kNumberOfImage = 4;
@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建ScrollView
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kkDeviceWidth, kkDeviceHeight)];
    scrollView.contentSize=CGSizeMake(kkDeviceWidth*kNumberOfImage,kkDeviceHeight);
    scrollView.pagingEnabled=YES;
    [self.view addSubview:scrollView];
    //创建三个imageView
    for(int i=0;i<kNumberOfImage;i++){
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(kkDeviceWidth*i, 0, kkDeviceWidth,kkDeviceHeight)];
        NSString *path;
        
        if(iPhone4){
             path=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"0%d_640@2x",i+1] ofType:@"png"];
        }else{
            path=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"0%d_750@2x",i+1] ofType:@"png"];
        }
        imageView.image=[UIImage imageWithContentsOfFile:path];
        scrollView.showsHorizontalScrollIndicator=NO;
        [scrollView addSubview:imageView];
        if(i==kNumberOfImage-1){
            //设置第三页的按钮
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            //btn.backgroundColor=[UIColor redColor];
            btn.frame=CGRectMake(0,kkDeviceHeight-50, kkDeviceWidth, 50);
            [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled=YES;
            [imageView addSubview:btn];
        }
    }
}
-(void)clickBtn
{
    MyTabBarController *mtbc=[[MyTabBarController alloc]initWithType:1 andSelectedIndex:0];
    [self presentViewController:mtbc animated:YES completion:^{
        [mUserDefaults setBool:YES forKey:@"isFirstStart"];
        [mUserDefaults synchronize];
        
        WINDOW.rootViewController=mtbc;
    }];
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
