//
//  OrderPriceView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "OrderPriceView.h"
#import "XHDHelper.h"

@implementation OrderPriceView
{
    UILabel *priceTitleLab;  //价格Labe
    UILabel *priceAmountLab;  //价格Labe
    UIControl *chooseJuanControl;//选劵Contrl
    
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

- (void)SetDisPlayVeiw
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    priceTitleLab = [XHDHelper createLabelWithFrame:mRect(25,5, 100, 30) andText:@"作品价格" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:priceTitleLab];

    priceAmountLab =  [XHDHelper createLabelWithFrame:mRect(25,5, 120, 30) andText:_priceStr.length?[NSString stringWithFormat:@"%@元",_priceStr]:@"0.00元" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    priceAmountLab.right = self.width -25;
    priceAmountLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:priceAmountLab];
    
    //分割线
    [XHDHelper addDivLineWithFrame:mRect(25, 40, kkDeviceWidth-50, 0.4) SuperView:self];
    
    chooseJuanControl = [[UIControl alloc]initWithFrame:mRect(0, 40, kkDeviceWidth, 40)];
    chooseJuanControl.backgroundColor = [UIColor clearColor];
    [self addSubview:chooseJuanControl];
    [chooseJuanControl addTarget:self action:@selector(gotoChooseJuan) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSString *tipsStr = [NSString stringWithFormat:@"可用书家劵%@%%，可用墨品劵%@%%",_SjJuan,_MpJuan];
    UILabel *tipsLab =  [XHDHelper createLabelWithFrame:mRect(25,5, chooseJuanControl.width-80, 30) andText:tipsStr andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
    [chooseJuanControl addSubview:tipsLab];
    
    UIButton *rightArrow = [XHDHelper getRightArrowButtonWith:mRect(chooseJuanControl.width-38, 10, 13,20)];
    rightArrow.right = self.width-25;
    [chooseJuanControl addSubview:rightArrow];
}

//TODO:设置选择后的展示
- (void)setFinishedChooseDisplayView
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    /*价格*/
    priceTitleLab = [XHDHelper createLabelWithFrame:mRect(25,5, 100, 30) andText:@"作品价格" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:priceTitleLab];
    
    priceAmountLab =  [XHDHelper createLabelWithFrame:mRect(25,5, 120, 30) andText:_priceStr andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    priceAmountLab.right = self.width -25;
    priceAmountLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:priceAmountLab];
    
    //分割线
    [XHDHelper addDivLineWithFrame:mRect(25, 40, kkDeviceWidth-50, 0.4) SuperView:self];
    
    //可用劵
    UILabel * canUseJuan = [XHDHelper createLabelWithFrame:mRect(25,45, 100, 30) andText:@"可用劵" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:canUseJuan];
    
    //书家劵
    UILabel * useSJJuanLab =  [XHDHelper createLabelWithFrame:mRect(25,45, 170, 30) andText:[NSString stringWithFormat:@"书家劵  %@元",_usedSjJuan.length?_usedSjJuan:@"0.00"] andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    useSJJuanLab.right = self.width -25;
    useSJJuanLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:useSJJuanLab];
    
    //墨品卷
    UILabel *  useMPJuan =  [XHDHelper createLabelWithFrame:mRect(25,80, 170, 30) andText:[NSString stringWithFormat:@"墨品劵  %@元",_usedMpJuan.length?_usedMpJuan:@"0.00"] andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    useMPJuan.right = self.width -25;
    useMPJuan.textAlignment = NSTextAlignmentRight;
    [self addSubview:useMPJuan];
    
    //分割线
    [XHDHelper addDivLineWithFrame:mRect(25, useMPJuan.bottom+7, kkDeviceWidth-50, 0.4) SuperView:self];
    
    //用劵折扣
    UILabel * useJuanCount = [XHDHelper createLabelWithFrame:mRect(25,useMPJuan.bottom+10, 100, 30) andText:@"用劵折扣" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:useJuanCount];
    
    //折价
    UILabel *  totalCount =  [XHDHelper createLabelWithFrame:mRect(25,useMPJuan.bottom+10, 170, 30) andText:[NSString stringWithFormat:@"￥%@",_usedTotalAmount.length?_usedTotalAmount:@"0.00"] andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
    totalCount.right = self.width -25;
    totalCount.textAlignment = NSTextAlignmentRight;
    [self addSubview:totalCount];
    
    UIControl *selectControl = [[UIControl alloc]initWithFrame:mRect(0, 40, kkDeviceWidth, 105)];
    selectControl.backgroundColor =[UIColor clearColor];
    [self addSubview:selectControl];
    [selectControl addTarget:self action:@selector(gotoChooseJuan) forControlEvents:UIControlEventTouchUpInside];
    
    //发送通知，改变控制器的高度
    self.height = 155;
}

#pragma  mark -- 以上的两个方法合并的一个
- (void)InitUI
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    priceTitleLab = [XHDHelper createLabelWithFrame:mRect(25,5, 100, 30) andText:@"作品价格" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:priceTitleLab];
    
    priceAmountLab =  [XHDHelper createLabelWithFrame:mRect(25,5, 120, 30) andText:_priceStr.length?[NSString stringWithFormat:@"%@元",_priceStr]:@"0.00元" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    priceAmountLab.right = self.width -25;
    priceAmountLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:priceAmountLab];
    
    //分割线
    [XHDHelper addDivLineWithFrame:mRect(25, 40, kkDeviceWidth-50, 0.4) SuperView:self];
    
    if((_usedMpJuan.length==0&&_usedSjJuan.length==0))
    {
        chooseJuanControl = [[UIControl alloc]initWithFrame:mRect(0, 40, kkDeviceWidth, 40)];
        chooseJuanControl.backgroundColor = [UIColor clearColor];
        [self addSubview:chooseJuanControl];
        [chooseJuanControl addTarget:self action:@selector(gotoChooseJuan) forControlEvents:UIControlEventTouchUpInside];
        
        
        NSString *tipsStr = [NSString stringWithFormat:@"可用书家劵%@%%，可用墨品劵%@%%",_SjJuan,_MpJuan];
        UILabel *tipsLab =  [XHDHelper createLabelWithFrame:mRect(25,5, chooseJuanControl.width-80, 30) andText:tipsStr andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
        [chooseJuanControl addSubview:tipsLab];
        
        UIButton *rightArrow = [XHDHelper getRightArrowButtonWith:mRect(chooseJuanControl.width-38, 10, 13,20)];
        rightArrow.right = self.width-25;
        [chooseJuanControl addSubview:rightArrow];

    
    }else{
    
        //可用劵
        UILabel * canUseJuan = [XHDHelper createLabelWithFrame:mRect(25,45, 100, 30) andText:@"可用劵" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
        [self addSubview:canUseJuan];
        
        //书家劵
        UILabel * useSJJuanLab =  [XHDHelper createLabelWithFrame:mRect(25,45, 170, 30) andText:[NSString stringWithFormat:@"书家劵  %@元",_usedSjJuan.length?_usedMpJuan:@"0.00"] andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
        useSJJuanLab.right = self.width -25;
        useSJJuanLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:useSJJuanLab];
        
        //墨品卷
        UILabel *  useMPJuan =  [XHDHelper createLabelWithFrame:mRect(25,80, 170, 30) andText:[NSString stringWithFormat:@"墨品劵  %@元",_usedMpJuan.length?_usedMpJuan:@"0.00"] andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
        useMPJuan.right = self.width -25;
        useMPJuan.textAlignment = NSTextAlignmentRight;
        [self addSubview:useMPJuan];
        
        //分割线
        [XHDHelper addDivLineWithFrame:mRect(25, useMPJuan.bottom+7, kkDeviceWidth-50, 0.4) SuperView:self];
        
        //用劵折扣
        UILabel * useJuanCount = [XHDHelper createLabelWithFrame:mRect(25,useMPJuan.bottom+10, 100, 30) andText:@"用劵折扣" andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
        [self addSubview:useJuanCount];
        
        //折价
        UILabel *  totalCount =  [XHDHelper createLabelWithFrame:mRect(25,useMPJuan.bottom+10, 170, 30) andText:[NSString stringWithFormat:@"￥%@",_usedTotalAmount.length?_usedTotalAmount:@"0.00"] andFont:UIFONT(13) AndBackGround:[UIColor clearColor] AndTextColor:THEMECOLOR_1];
        totalCount.right = self.width -25;
        totalCount.textAlignment = NSTextAlignmentRight;
        [self addSubview:totalCount];
        
        UIControl *selectControl = [[UIControl alloc]initWithFrame:mRect(0, 40, kkDeviceWidth, 105)];
        selectControl.backgroundColor =[UIColor clearColor];
        [self addSubview:selectControl];
        [selectControl addTarget:self action:@selector(gotoChooseJuan) forControlEvents:UIControlEventTouchUpInside];
        
        //发送通知，改变控制器的高度
        self.height = 155;
    }
}

#pragma  mark -- 去选劵
-(void)gotoChooseJuan
{
    if([_delegate respondsToSelector:@selector(toChooseJuan)])
    {
        [_delegate toChooseJuan];
    }
    
}

@end
