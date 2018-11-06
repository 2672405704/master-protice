//
//  UIRadioControl.m
//  MopinProject
//
//  Created by xhd945 on 15/12/9.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "UIRadioControl.h"
#define BOTTONLINEHEIGHT 2.0
#define rBntFont 16

@implementation UIRadioControl

@synthesize selectedIndex = _selectedIndex;

// 初始化方法 （设置了frame 以及玩法选择按钮）
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        _itemss = items;
        [self setItems:items];
    }
    return self;
}

#pragma mark 设置是否允许轻扫
- (void)setEnableSwipe:(BOOL)enableSwipe
{
   if(enableSwipe)
   {
       // 创建手势
       _swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
       _swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
       [self addGestureRecognizer:_swipeGesture];
       
       UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureAction:)];
       rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
       [self addGestureRecognizer:rightSwipe];
   }

}

#pragma mark -- 按钮数组(自定义按钮）
-(void)setItems:(NSArray*)items
{
    int count = (int)[items count];
    CGFloat button_width = self.width / count;
    CGFloat button_height = self.height;
    
    // 移除所有的子视图
    [self removeAllSubviews];
    
    for (int i = 0; i < count; i++)
    {
    
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:RGBA(202, 59, 43, 1) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:rBntFont];
        
        [button addTarget:self action:@selector(tabBarClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = i;
        button.frame = CGRectMake(i*button_width,0,button_width,button_height);
        [self addSubview:button];
    }
    
    //底部的线
    _bottonLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/items.count/4.0,self.height - BOTTONLINEHEIGHT, self.frame.size.width/items.count/2.0, BOTTONLINEHEIGHT)];
    _bottonLine.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottonLine];
    
    
}

#pragma mark -- 设置字体大小
- (void)setFont:(UIFont *)font
{
    for (UIButton *button in self.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
            button.titleLabel.font = font;
    }
}

#pragma mark -- 根据状态置title颜色的方法
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (state == UIControlStateSelected)
    {
        _bottonLine.backgroundColor = color;
    }
    
    for (UIButton *button in self.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
           [button setTitleColor:color forState:state];
        }
        
    }
}

#pragma 轻扫事件响应
-(void)swipeGestureAction:(UISwipeGestureRecognizer *)swipe
{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {// 右滑
        _selectedIndex = _selectedIndex+1;
        
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {// 左滑
        if (_selectedIndex >=1)
        {
            _selectedIndex = _selectedIndex-1;
        }
    }
    
    if (_selectedIndex <= 0)
    {
        _selectedIndex = 0;
    }
    
    else if (_selectedIndex >= _itemss.count)
    {
        _selectedIndex = 0;
    }
    
    [self tabBarClick:[self.subviews objectAtIndex:_selectedIndex]];
    
    [self setSelectedIndex:_selectedIndex];
    
}

#pragma mark --  判断选中的是那个按钮,相当于按钮的点击事件
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    //改变底部分割线的位置
    [UIView animateWithDuration:0.3 animations:^{
        
        _bottonLine.frame = CGRectMake(self.frame.size.width/_itemss.count*_selectedIndex + self.frame.size.width/_itemss.count/4.0,self.height - BOTTONLINEHEIGHT, self.frame.size.width/_itemss.count/2.0, BOTTONLINEHEIGHT);
    }];
    
    
    for (UIView *subView in self.subviews)
    {
        if([subView isKindOfClass:[UIButton class]])
        {
            UIButton*button = (UIButton*)subView;
            if (button.tag == selectedIndex)
            {
                button.selected = YES;
            }
            else
            {
                button.selected = NO;
            }
        }
        
        
    }
}

#pragma mark --  获取被选中的按钮的title
- (NSString *)titleForSelectedIndex:(NSUInteger )index
{
    NSString *title = NULL;
    for (UIButton *button in self.subviews)
    {
        if (button.tag == index)
        {
            title = [NSString stringWithFormat:@"%@",[button titleForState:UIControlStateNormal]];
            break;
        }
    }
    return title;
}

#pragma mark -- 按钮点击
- (void)tabBarClick:(UIButton *)button
{
    if (!button.isSelected)
    {
        for (UIButton *button in self.subviews)
        {
            if ([button isKindOfClass:[UIButton class]])
                button.selected = NO;
        }
        
        button.selected = YES;
        _selectedIndex = button.tag;
        
        //改变底部分割线的位置
        [UIView animateWithDuration:0.3 animations:^{
           
            _bottonLine.frame = CGRectMake(self.frame.size.width/_itemss.count*_selectedIndex + self.frame.size.width/_itemss.count/4.0,self.height - BOTTONLINEHEIGHT, self.frame.size.width/_itemss.count/2.0, BOTTONLINEHEIGHT);
        }];
        // 该方法说明只要是controll的子类都可以调用（事件分发）
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark --  改变不同个数button有不同的布局
- (void)changeRadioWidth:(float)newWidth
{
    [self setWidth:newWidth];
    
    float childWidth = newWidth/self.subviews.count;
    float childLeft = 0;
    
    if (self.subviews.count > 5)
    {
        childWidth =newWidth/5;
    }
    for (UIView *childView in self.subviews)
    {
        [childView setWidth:childWidth];
        [childView setLeft:childLeft];
        childLeft += childWidth;
    }
}

#pragma mark -- 画分割线
-(void)drawRect:(CGRect)rect
{
    // 图形上下文，得到一个画笔，画布是view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //绘制底部分割线
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineWidth(context,1.5f);
    CGContextSetStrokeColorWithColor(context,DIVLINECOLOR_1.CGColor);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context,rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context,rect.size.width, rect.origin.y);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    CGContextMoveToPoint(context,rect.origin.x, rect.size.height );
    CGContextAddLineToPoint(context,rect.size.width, rect.size.height);
    CGContextDrawPath(context,kCGPathFillStroke);
    
    /*
     * @kCGPathFill, 设置填充
     * @kCGPathStroke, 设置线条
     * @kCGPathFillStroke, 两者兼有
     */
    
    CGContextSetLineWidth(context,0.8f);
    //绘制竖线
    for (int i = 1; i < _itemss.count; i++)
    {
        // 画笔的起始坐标
        CGContextMoveToPoint(context, kkDeviceWidth /_itemss.count*i, 10);
        CGContextAddLineToPoint(context, kkDeviceWidth/_itemss.count*i, self.height-10);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}


// 移除所有子视图
- (void)removeAllSubviews
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
@end
