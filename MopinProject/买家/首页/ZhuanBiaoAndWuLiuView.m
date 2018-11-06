//
//  ZhuanBiaoAndWuLiuView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "ZhuanBiaoAndWuLiuView.h"
#import "XHDHelper.h"

@implementation ZhuanBiaoAndWuLiuView

{
    UILabel *ZhuanBiaoTitleLab; //装裱标题
    UILabel *WuliuTitleLab; //物流标题
    UILabel *WuliuPriceLab; //物流价格
    UILabel *ZhuanBiaoPriceLab; //装裱价格
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}
#pragma mark -- 画分割线
-(void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.0f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR_1.CGColor);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context,rect.size.width, rect.origin.y);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    /*
    CGContextSetLineWidth(context,0.5f);
    CGContextMoveToPoint(context,rect.origin.x+25, rect.size.height/2.0);
    CGContextAddLineToPoint(context,rect.size.width-25, rect.size.height/2.0);
    CGContextDrawPath(context,kCGPathFillStroke);
    */
    
    CGContextSetLineWidth(context,1.0f);
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
}

-(void)_initUI
{
    for(UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    
    
    
    self.backgroundColor = [UIColor whiteColor];
    ZhuanBiaoTitleLab = [XHDHelper createLabelWithFrame:mRect(25, 0, 80, 40) andText:@"装裱价格" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:ZhuanBiaoTitleLab];
    
    /*物流价格===暂时屏蔽*/
    /*
    WuliuTitleLab = [XHDHelper createLabelWithFrame:mRect(25, 40, 80, 40) andText:@"物流/快递" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:WuliuTitleLab];
    */
    
    ZhuanBiaoPriceLab = [XHDHelper createLabelWithFrame:mRect(25, 0, 140, 40) andText:_zhuanBiaoPrice.length?[NSString stringWithFormat:@"%@元",_zhuanBiaoPrice]:@"0.00元" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    ZhuanBiaoPriceLab.right = self.width-25;
    ZhuanBiaoPriceLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:ZhuanBiaoPriceLab];
    
    /*物流价格===暂时屏蔽*/
    /*
    WuliuPriceLab = [XHDHelper createLabelWithFrame:mRect(25,40, 140, 40) andText:_wuliuPrice.length?[NSString stringWithFormat:@"%@",_wuliuPrice]:@"0.00元" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    WuliuPriceLab.right = self.width-25;
    WuliuPriceLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:WuliuPriceLab];
    */
  
    self.height = 40;
}



@end
