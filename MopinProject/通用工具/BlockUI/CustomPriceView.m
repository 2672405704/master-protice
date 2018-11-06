//
//  CustomPriceView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CustomPriceView.h"

@implementation CustomPriceView
{
  UILabel *_PriceLab; //价格Label
}
-(void)setPrice:(NSString *)price
{
    if(_price!=price)
    {
        _price = price;
    }
    _PriceLab.text = price;
    [self _initUI];
    
}
- (instancetype)initWithFrame:(CGRect)frame WithPrice:(NSString*)priceStr
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _price = priceStr;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        [self _initUI];
    }
    return self;
}

-(void)_initUI
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
        
    }
   //￥
    UILabel *Label_1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 13, 10)];
    Label_1.text =@"￥";
    Label_1.textColor = [UIColor whiteColor];
    Label_1.textAlignment = NSTextAlignmentCenter;
    Label_1.font = [UIFont systemFontOfSize:13];
    [self addSubview:Label_1];
    
    //价格Label
    _PriceLab = [[UILabel alloc]initWithFrame:CGRectMake(Label_1.frame.size.width+11, Label_1.origin.y-8, 50, 30)];
    _PriceLab.text =_price;
    _PriceLab.textColor = [UIColor whiteColor];
    _PriceLab.textAlignment = NSTextAlignmentLeft;
    _PriceLab.font = [UIFont systemFontOfSize:19];
    [self addSubview:_PriceLab];
}

-(void)layoutSubviews
{
    CGFloat width = [_price sizeWithAttributes:@{NSFontAttributeName:_PriceLab.font}].width;
    _PriceLab.width = width+3;
    self.frame  = CGRectMake(self.frame.origin.x, self.frame.origin.y,width+35, self.frame.size.height);
}


@end
