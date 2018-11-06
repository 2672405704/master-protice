//
//  SixthSectionView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "SixthSectionView.h"
#import "CustomTitleView.h"
#import "MinQianShiView.h"
#import "XHDHelper.h"
#import "UIKit+AFNetworking.h"

@implementation SixthSectionView
{
    UILabel *introduceLab;//介绍Label
    UILabel *runGeLab; //润格Label
    UIButton* checkAllBnt; //查看全部
    UIImageView *headerIcon;
    UILabel *titleLab;
    MinQianShiView *mqsView;//书家标签
    CGFloat h;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        h = 0;
        [self initDisplayView];
        
    }
    return self;
}

- (void)initDisplayView
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    CustomTitleView *  logoTitView = [[CustomTitleView alloc]initWithFrame:mRect(self.width/2.0-50, 20, 100,20) AndImageName:@"user_multiple" AndTitleName:@"书家介绍"];
    [self addSubview:logoTitView];
    
    //头像
    headerIcon  = [XHDHelper createImageViewWithFrame:mRect(self.width/2.0-30,logoTitView.bottom+15,60,60) AndImageName:PlaceHeaderImage AndCornerRadius:30 andGestureRecognizer:1 AndTarget:self AndAction:@selector(jumpToPenmanMainPage:)];
    [headerIcon setImageWithURL:[NSURL URLWithString:_Photo] placeholderImage:mImageByName(PlaceHeaderIconImage)];
    [self addSubview:headerIcon];
    
    
    //书家名字
    titleLab = [XHDHelper createLabelWithFrame:mRect(25, headerIcon.bottom+5, self.width-50, 30) andText:_PenmanName.length?_PenmanName:@"匿名" andFont:UIFONT_Tilte(16) AndBackGround:[UIColor clearColor] AndTextColor:TitleFontColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    
    //名（书家类型）
    mqsView = [[MinQianShiView alloc]initWithFrame:mRect(0,titleLab.bottom+10, 70, 30)];
    mqsView.Category = _PenmanType.length?_PenmanType: @"3";
    mqsView.isSigned = _IsBooked.length?_IsBooked: @"1";
    mqsView.Trend = _Trend.length?_Trend:@"1";
    [self addSubview:mqsView];
    mqsView.center = CGPointMake(self.width/2.0,titleLab.bottom+10);
    [mqsView initDisPlayView];
    NSLog(@"%lf",mqsView.width);
    
    //介绍
    introduceLab = [XHDHelper createLabelWithFrame:mRect(25, mqsView.bottom+5, self.width-110, 16) andText:_Signature.length?_Signature:@"该书家暂未有任何介绍。" andFont:UIFONT_Tilte(12.5) AndBackGround:[UIColor clearColor] AndTextColor:TipsFontColor];
    introduceLab.numberOfLines = 1;
    [self addSubview:introduceLab];
    
    //全文按钮
    checkAllBnt =[XHDHelper createButton:mRect(introduceLab.right+5, introduceLab.origin.y, 50,16) NomalTitle:@"【全文】" SelectedTitle:@"【收起】" NomalTitleColor:THEMECOLOR_1 SelectTitleColor:THEMECOLOR_1 NomalImage:nil SelectedImage:nil BoardLineWidth:0.0000f target:self selector:@selector(checkAllBntAction:)];
    checkAllBnt.titleLabel.font = UIFONT(12.5);
    
    [self addSubview:checkAllBnt];
    
    //润格
    NSString *runGeContent = [NSString stringWithFormat:@"润格 %ld元/平尺   卷价 %ld元/件",_NPrice.length?_NPrice.integerValue:0,_AveragePrice.length?_AveragePrice.integerValue:0];
    runGeLab = [XHDHelper createLabelWithFrame:mRect(introduceLab.origin.x, introduceLab.bottom+10, self.width-50, 15) andText:runGeContent andFont:[UIFont systemFontOfSize:13.5]  AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    
    [self addSubview:runGeLab];
}

/*跟新UI*/
- (void)UpdateUI
{
    titleLab.text = _PenmanName.length?_PenmanName:@"匿名";
    runGeLab.text =[NSString stringWithFormat:@"润格 %ld元/平尺   卷价 %ld元/件",_NPrice.length?_NPrice.integerValue:0 ,_AveragePrice.length?_AveragePrice.integerValue:0 ];
    introduceLab.text = _Signature.length?_Signature:@"该书家暂未有任何介绍。";
    mqsView.Category = _PenmanType.length?_PenmanType: @"3";
    mqsView.isSigned = _IsBooked.length?_IsBooked: @"0";
    mqsView.Trend = _Trend.length?_Trend:@"0";
    [mqsView initDisPlayView];
    
    mqsView.width = [_IsBooked isEqualToString:@"0"]?45.f:70.f;
    mqsView.frame = mRect((kkDeviceWidth-mqsView.width)/2.0,mqsView.origin.y, mqsView.width, mqsView.height);
   
    
    [headerIcon setImageWithURL:[NSURL URLWithString:_Photo] placeholderImage:mImageByName(PlaceHeaderIconImage)];
    
}

- (void)checkAllBntAction:(UIButton*)sender
{
    sender.selected = !sender.isSelected;
    if(sender.isSelected)
    {
    introduceLab.text  = _Signature.length?_Signature:@"该书家暂未有任何介绍。";
     h = [XHDHelper heightOfString:introduceLab.text font:introduceLab.font maxSize:CGSizeMake(self.width-50, 1000)].height;
    introduceLab.height = h+5;
    introduceLab.numberOfLines  = 0;
    introduceLab.width = self.width-50;

    checkAllBnt.top = introduceLab.bottom +5;
    checkAllBnt.right = introduceLab.right;
    
    runGeLab.top = checkAllBnt.bottom + 5;
    }
    else{
    
        introduceLab.text  = _Signature.length?_Signature:@"该书家暂未有任何介绍。";
        introduceLab.height = 16;
        introduceLab.width = self.width-110;
        introduceLab.numberOfLines  = 1;
        checkAllBnt.top = introduceLab.origin.y;
        checkAllBnt.left = introduceLab.right+5;
        
        h = 16-h;

        runGeLab.top = checkAllBnt.bottom + 5;
    }
    
  //发送通知改变ScrollView的高度
    NSDictionary *dic = @{@"changHeight":[NSString stringWithFormat:@"%lf",h]};
    [mNotificationCenter postNotificationName:@"changeScrollViewHeight" object:nil userInfo:dic];
    
}
#pragma mark -- 跳到书家主页
-(void)jumpToPenmanMainPage:(UITapGestureRecognizer*)tap
{
   /*书家主页*/
    if([_delegate respondsToSelector:@selector(checkPenManDetailWithPenManID:)])
    {
        [_delegate checkPenManDetailWithPenManID:_PenmanID];
    
    }
}


@end
