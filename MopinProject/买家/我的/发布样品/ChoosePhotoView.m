//
//  ChoosePhotoView.m
//  MopinProject
//
//  Created by rt008 on 15/11/29.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ChoosePhotoView.h"

@implementation ChoosePhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    UITapGestureRecognizer *tap=[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(<#selector#>)
    
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0,(kkDeviceHeight-135)/2, kkDeviceWidth-60, 135)];
    bgView.backgroundColor=[UIColor whiteColor];
    
    bgView.layer.cornerRadius=3;
    bgView.layer.masksToBounds=YES;
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame),44)];
    titleLabel.text=@"从相册选择";
    titleLabel.font=[UIFont systemFontOfSize:15];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor whiteColor];
    
    [bgView addSubview:titleLabel];
    
    UIButton *photoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [photoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    photoBtn.backgroundColor=[UIColor whiteColor];
    photoBtn.frame=CGRectMake(0, 45, kkDeviceWidth, 44);
    [photoBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:photoBtn];
    
    NSArray *titleArr=@[@"取消",@"确定"];
    for(int i=0;i<2;i++){
        UIButton *photoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [photoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [photoBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        photoBtn.backgroundColor=[UIColor whiteColor];
        photoBtn.frame=CGRectMake(((kkDeviceWidth-60-1)/2+1)*i,90, (kkDeviceWidth-60-1)/2, 44);
        [photoBtn addTarget:self action:@selector(boomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:photoBtn];
        
        photoBtn.tag=100+i;
    }
}
//TODO:点击取消 或确定
- (void)boomBtnClick:(UIButton *)button{
    
}
//TODO:拍照
- (void)takePhotoBtnClick
{
    
}
@end
