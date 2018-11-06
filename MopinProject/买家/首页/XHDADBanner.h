//
//  JCGADBanner.h
//  UIScrollView循环移动
//
//  Created by MacEdward on 15/1/27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^jumpIntoAdView)(NSInteger mark);

@interface XHDADBanner : UIView<UIScrollViewDelegate> //设置代理

/*创建翻页控制器*/
@property(nonatomic,strong)UIPageControl *pageControl;
/*当前是第几页*/
@property (nonatomic,strong)UILabel *currentPageLab;
/*背景*/
@property(nonatomic,strong)UIView *pageContorBg;

//要显示的图片内容，每个元素为一个image对象的URL地址
@property (nonatomic, strong)NSArray *imageURLArr;

@property(nonatomic,strong)jumpIntoAdView  jumpBlock;

@property(nonatomic,weak) UIViewController *delegate; //代理

- (void)updateUI;

@end
