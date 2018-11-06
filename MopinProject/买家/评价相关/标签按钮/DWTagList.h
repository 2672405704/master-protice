//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseTagDelegate <NSObject>

@optional

- (void)chooseTagWithIndex:(NSInteger)index AndisChoose:(BOOL)isChoose;
- (void)chooseTagWithIndex:(NSInteger)index;

@end

@interface DWTagList : UIScrollView
{
    UIView *view;    //主视图
    NSArray *textArray;  //文本数组
    CGSize sizeFit;     //适配
    UIColor *lblBackgroundColor; //背景颜色
}

@property (nonatomic,assign)BOOL  isSingChoose;  //默认为YES
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, weak)id<ChooseTagDelegate> chooseTagDelegate;


- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end
