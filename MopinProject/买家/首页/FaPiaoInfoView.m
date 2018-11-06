//
//  FaPiaoInfoView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "FaPiaoInfoView.h"
#import "XHDHelper.h"

@implementation FaPiaoInfoView
{
    UIImageView*IconImag;  //选中的图标
    UILabel *contentLabel; //内容
    UIControl *control; //
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
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
    
    CGContextSetLineWidth(context,1.0f);
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
}
- (void)layoutSubviews
{
    [self _initUI];
    
}
-(void)_initUI
{
    for(UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
    control = [[UIControl alloc]initWithFrame:self.frame];
    [self addSubview:control];
    [control addTarget:self action:@selector(toFillFaPiaoInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    IconImag = [[UIImageView alloc]initWithFrame:mRect(25, 10, 20, 20)];
    IconImag.image = mImageByName(@"gou_red_sample");
    IconImag.hidden = _faPiaoContent.length?NO:YES;
    [self addSubview:IconImag];
    
    contentLabel = [XHDHelper createLabelWithFrame:mRect(IconImag.hidden?25:50, 0, self.width-70, 40) andText:_faPiaoContent.length?_faPiaoContent:@"开具装裱与物流发票" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toFillFaPiaoInfo:)];
    [contentLabel addGestureRecognizer:tap];

    [self addSubview:contentLabel];
    [self bringSubviewToFront:IconImag];
    
}
- (void)toFillFaPiaoInfo:(UIControl*)sender
{
   if([_delegate respondsToSelector:@selector(gotoFillFaPiaoInfo)])
   {
       [_delegate gotoFillFaPiaoInfo];
   }
}

@end
