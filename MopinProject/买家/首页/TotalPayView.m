//
//  TotalPayView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "TotalPayView.h"
#import "XHDHelper.h"

@implementation TotalPayView

{
    UILabel *ShiFuTitleLab; //实付标题
    UILabel *ShiFuPrice; //实付价格
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self _initUI];
    }
    return self;
}

/*设置价格*/
-(void)setPriceStr:(NSString *)priceStr
{
   if(priceStr != _priceStr)
   {
       _priceStr = priceStr;
   }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_priceStr.length?[NSString stringWithFormat:@"￥%.2f",_priceStr.floatValue ]:@"￥0.00元"];
    [str addAttributes:@{NSFontAttributeName:UIFONT_bold(18)} range:NSMakeRange(1, str.length-1)];
    ShiFuPrice.attributedText = str;
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
    
    CGContextSetLineWidth(context,1.0f);
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
}

-(void)_initUI
{
    self.backgroundColor = [UIColor whiteColor];
    ShiFuTitleLab = [XHDHelper createLabelWithFrame:mRect(25, 0, 80, 40) andText:@"实付" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:ShiFuTitleLab];
    
    ShiFuPrice = [XHDHelper createLabelWithFrame:mRect(0, 0, 180, 40) andText:@"0.00" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
    ShiFuPrice.right = self.width - 25;
    ShiFuPrice.textAlignment = NSTextAlignmentRight;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_priceStr.length?[NSString stringWithFormat:@"￥%@",_priceStr]:@"￥0.00元"];
    [str addAttributes:@{NSFontAttributeName:UIFONT_bold(18)} range:NSMakeRange(1, str.length-1)];
    ShiFuPrice.attributedText = str;
    [self addSubview:ShiFuPrice];

}

@end
