//
//  MinQianShiView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "MinQianShiView.h"
#define BoardWidth 0.8

@implementation MinQianShiView
{
    BOOL isBook;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (void)initDisPlayView
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    //类型
    UILabel *minLab = [[UILabel alloc]initWithFrame:mRect(0, 5, 20, 20)];
    NSString *cateStr;
    if([_Category isEqualToString:@"0"])
    {
        cateStr = @"大";
    
    }else if([_Category isEqualToString:@"1"])
    {
      cateStr = @"名";
    }else
    {
      cateStr = @"书";
    }
    minLab.text = _Category.length?cateStr:@"书";
    minLab.textColor = THEMECOLOR_2;
    minLab.font = UIFONT(12);
    minLab.textAlignment = NSTextAlignmentCenter;
    minLab.layer.cornerRadius = 10;
    minLab.layer.borderColor = THEMECOLOR_2.CGColor;
    minLab.layer.borderWidth = BoardWidth;
    minLab.layer.shouldRasterize = YES;
    [self addSubview:minLab];
    
    //是否签约
    isBook = [_isSigned isEqualToString:@"1"];
    UILabel *signLab;
    if(isBook)
    {
        signLab = [[UILabel alloc]initWithFrame:mRect(minLab.right+5, 5, 20, 20)];
        signLab.text = @"签";
        signLab.textColor = THEMECOLOR_1;
        signLab.font = UIFONT(12);
        signLab.textAlignment = NSTextAlignmentCenter;
        signLab.layer.cornerRadius = 10;
        signLab.layer.borderColor = THEMECOLOR_1.CGColor;
        signLab.layer.borderWidth = BoardWidth;
        signLab.layer.shouldRasterize = YES;
        [self addSubview:signLab];
    
    }
    //势
    UIImageView *trendLab = [[UIImageView alloc]initWithFrame:mRect(isBook?50:25, 5, 20, 20)];
    trendLab.image = mImageByName(@"up_icon_penmanList");
    if([_Trend isEqualToString:@"-1"]) //下降
    {
         trendLab.image = mImageByName(@"down_icon_penman");
        
    }else if([_Trend isEqualToString:@"0"])//不变
    {
          trendLab.image = mImageByName(@"right_icon_penmanList");
    
    }else //上升
    {
        trendLab.image = mImageByName(@"up_icon_penmanList");
    }
    trendLab .layer.cornerRadius = 10;
    trendLab .layer.borderColor = TipsFontColor.CGColor;
    trendLab .layer.borderWidth = BoardWidth;
    trendLab .layer.shouldRasterize = YES;
    [self addSubview:trendLab];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.width = [_isSigned isEqualToString:@"0"]?45.f:70.f;
}

@end
