//
//  ZKFCustomButton.m
//  MopinProject
//
//  Created by rt008 on 15/11/25.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "ZKFCustomButton.h"

@implementation ZKFCustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    
    return CGRectMake(0, 10, imageW, 21);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height *0.6;
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
