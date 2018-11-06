//
//  CustomBannerView.m
//  MopinProject
//
//  Created by rt008 on 15/12/1.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CustomBannerView.h"
#import "ImageModel.h"
#import "UIImageView+WebCache.h"

@interface CustomBannerView()<UIScrollViewDelegate>
{
    NSTimer *_timer;
    NSArray *_imageArr;
    UIScrollView *_scrollView;
}
@end

@implementation CustomBannerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr
{
    self=[super initWithFrame:frame];
    if(self){
        _imageArr=imageArr;
        [self createUI];
    }
    return self;
}
//TODO:创建视图
- (void)createUI
{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
    _scrollView.delegate=self;
    _scrollView.pagingEnabled=YES;
    _scrollView.contentSize=CGSizeMake(_imageArr.count*CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame));
    [self addSubview:_scrollView];
    for(int i=0;i<_imageArr.count;i++){
        ImageModel *model=_imageArr[i];
        
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds=YES;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:mImageByName(PlaceHeaderSquareImage)];
        imageView.backgroundColor=mRGBColor(rand()%255, rand()%255, rand()%255);
        [_scrollView addSubview:imageView];
    }
    _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}
//TODO:改变图片
- (void)changeImage
{
    _scrollView.contentOffset=CGPointMake(_scrollView.frame.size.width+_scrollView.contentOffset.x, 0);
    if(_scrollView.contentOffset.x>=_imageArr.count*_scrollView.frame.size.width){
        _scrollView.contentOffset=CGPointMake(0, 0);
    }
}
#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _countLabel.text=[NSString stringWithFormat:@"%d/%@",(int)(scrollView.contentOffset.x/scrollView.frame.size.width)+1,@(_imageArr.count)];
}
- (void)dealloc
{
    [_timer invalidate];
}
@end
