//
//  UIRadioControl.h
//  MopinProject
//
//  Created by xhd945 on 15/12/9.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRadioControl : UIControl
{
    NSUInteger _selectedIndex; // 选择的button的是第几个
    UISwipeGestureRecognizer *_swipeGesture;// 轻扫手势
    NSArray *_itemss;  //数组元素
    UIImageView *_bottonLine; //底部的线
}

@property(nonatomic,assign)BOOL enableSwipe;
@property (nonatomic, assign) NSUInteger selectedIndex;

//根据数组和frame初始化
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

//设置字体
- (void)setFont:(UIFont *)font;

//根据转态设置字体颜色
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;

//获取选择的标题
- (NSString *)titleForSelectedIndex:(NSUInteger )index;

//设置元素
-(void)setItems:(NSArray*)items;


//改变宽度
- (void)changeRadioWidth:(float)newWidth;


@end
