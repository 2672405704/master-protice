//
//  JCGADBanner.m
//  UIScrollView循环移动
//
//  Created by MacEdward on 15/1/27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "XHDADBanner.h"
#import "UIKit+AFNetworking.h"
#import "ImgShowViewController.h"


@implementation XHDADBanner
{
    UIScrollView *sc;
    NSMutableArray *imgArr; //图片数组
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imgArr = [[NSMutableArray alloc]init];
        [self initUI];
    }
    return self;
}
-(void)dealloc
{
   for(UIView *view in self.subviews)
   {
       [view removeFromSuperview];
   }
    [self removeFromSuperview];
   
}

#pragma mark -- 设置显示当前是第几张图片的
- (void)addShowPageNumberLab
{
    _currentPageLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    _currentPageLab.textAlignment = NSTextAlignmentCenter;
    _currentPageLab.textColor = [UIColor whiteColor];
    _currentPageLab.text = [NSString stringWithFormat:@"%@ / %@",@(0),@(_imageURLArr.count)];
    _currentPageLab.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:_currentPageLab];
}

#pragma mark -- 初始化数组
-(void)setImageURLArr:(NSArray *)imageURLArr
{
   if(imageURLArr != _imageURLArr)
   {
       _imageURLArr = imageURLArr;
   }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI];
        _currentPageLab.text = [NSString stringWithFormat:@"%@ / %@",_imageURLArr.count?@"1":@"0",@(_imageURLArr.count)];
        
    });
}


#pragma mark -- 刷新UI
- (void)initUI
{
    /*背景*/
    sc = [[UIScrollView alloc]init];
    sc.tag =101;
    sc.frame = self.frame;
    sc.bounces = NO;  //关闭弹簧效果
    sc.pagingEnabled = YES; //打开翻页效果
    sc.delegate = self; // 设置代理
    [self addSubview:sc];
    
    
    /*设置翻页控制器背景视图*/
    _pageContorBg = [[UIView alloc]init];
    _pageContorBg.frame = CGRectMake(0, self.height-30, kkDeviceWidth, 30);
    _pageContorBg.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    _pageContorBg.alpha = 1.0;
    [self addSubview:_pageContorBg];
    
    /*实例化翻页控制器*/
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.frame = CGRectMake(kkDeviceWidth/2.0-100, 0, 200, 30);
    //当前圆点的颜色
    _pageControl.currentPageIndicatorTintColor = THEMECOLOR_1;
    //其他圆点的颜色
    _pageControl.pageIndicatorTintColor = DIVLINECOLOR_1;
    [_pageContorBg addSubview:_pageControl];
    
    /*添加指示图片*/
    [self addShowPageNumberLab];
    _currentPageLab.right = _pageContorBg.right;
    _currentPageLab.top = self.bottom-40;
    
    //通过计时器实现定时
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(update) userInfo:nil repeats:YES];

}

#pragma mark -- 设置展示的图片
- (void)updateUI
{
    for(UIImageView *imgV in sc.subviews)
    {
        [imgV removeFromSuperview];
    }
    
    //设置翻页控制器的小圆点个数
    _pageControl.numberOfPages = _imageURLArr.count;
    
    /*设置将要显示的图片*/
    NSInteger i;
    for (i=0; i<_imageURLArr.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake((i+1)*kkDeviceWidth, 0, kkDeviceWidth, self.height);
        [imageView setImageWithURL:[NSURL URLWithString:_imageURLArr[i]] placeholderImage:[UIImage imageNamed:@"banner"]];
        imageView.tag = 100+i;
        imageView.userInteractionEnabled = YES;
        //添加一个点击手势：
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(jumpToAd:)];
        [imageView addGestureRecognizer:tap];
        [sc addSubview:imageView];
        
        [imgArr addObject:[NSURL URLWithString:_imageURLArr[i]]];
    }
    
    /*设置初始页面*/
    sc.contentOffset = CGPointMake(kkDeviceWidth, 0);
    
    /*在滚动控制器上设置显示内容的大小*/
    sc.contentSize = CGSizeMake(kkDeviceWidth*(_imageURLArr.count + 2), self.height);
    
    /*添加冗余页面到第一张图片之前，将最后一张图片加到这个页面中*/
    UIImageView *first = [[UIImageView alloc]init];
    [first setImageWithURL:[NSURL URLWithString:[_imageURLArr lastObject]] placeholderImage:[UIImage imageNamed:@"banner"]];
    first.frame = CGRectMake(0, 0, kkDeviceWidth, self.height);
    [sc addSubview:first];
    
    /*添加冗余页面到最后一张图之后，将第一张图片加到这个页面*/
    UIImageView *last = [[UIImageView alloc]init];
    [last setImageWithURL:[NSURL URLWithString:[_imageURLArr firstObject]] placeholderImage:[UIImage imageNamed:@"banner"]];
    last.frame = CGRectMake(kkDeviceWidth*(_imageURLArr.count+1), 0, kkDeviceWidth, self.height);
    [sc addSubview:last];
    
}



#pragma mark -- imageView手势动作
-(void)jumpToAd:(UIPanGestureRecognizer*)sender
{
    NSInteger imageViewTag = sender.view.tag;
    if(_delegate)
    {
       ImgShowViewController *showVC = [[ImgShowViewController alloc]initWithSourceData:imgArr withIndex:imageViewTag];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:showVC];
        [_delegate.navigationController presentViewController:navi animated:YES completion:nil];
    
    }
}

//定时更新栏滚动显示图片
- (void)update
{
    //获取当前滚动去对象的坐标
    CGPoint offSet = sc.contentOffset;
    
    //将X坐标向下一个移动
    offSet.x += kkDeviceWidth;
    
    //设置页面小圆点来求出当前页面
    NSInteger page = (offSet.x -kkDeviceWidth) / kkDeviceWidth;
    
    //当前一共6张图片，当显示到4张（包括冗余为0和5）的时候，跳回第0张 重置x坐标和页面小圆点
    if (offSet.x == kkDeviceWidth *(_imageURLArr.count + 1)) {
        
        [sc setContentOffset:CGPointMake(0, 0) animated:NO];
        offSet.x =kkDeviceWidth;
        page = 0;
    }
    
    [sc setContentOffset:offSet animated:YES];
    _pageControl.currentPage = page;
    
    _currentPageLab.text = [NSString stringWithFormat:@"%@ / %@",@(_pageControl.currentPage+1),@(_imageURLArr.count)];
    
}

//scrollView停止加速（自己滑动）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    根据当前的页面计算出页数
    NSInteger page = (scrollView.contentOffset.x - kkDeviceWidth)/kkDeviceWidth;
    
    if (scrollView.contentOffset.x == 0) //第一张冗余图片
    {
        
        [scrollView setContentOffset:CGPointMake(kkDeviceWidth*(_imageURLArr.count), 0) animated:NO];
        
        page =_imageURLArr.count - 1;
        
    }
    if (scrollView.contentOffset.x == (_imageURLArr.count + 1)*kkDeviceWidth) //最后一张冗余图片
    {
        [scrollView setContentOffset:CGPointMake(kkDeviceWidth, 0) animated:NO];
        
        page =0;
        
    }
    _pageControl.currentPage = page;
    
    _currentPageLab.text = [NSString stringWithFormat:@"%@ / %@",@(_pageControl.currentPage+1),@(_imageURLArr.count)];
    
}
@end
