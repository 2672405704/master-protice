//
//  CommonEmptyTableBgView.m
//  MopinProject
//
//  Created by xhd945 on 16/1/4.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "CommonEmptyTableBgView.h"

@implementation CommonEmptyTableBgView
{
    UIImageView *IconImageView; //图标
    UILabel * tipsLabel; //提示图标

}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _tipsString = @"哦噢，没有任何数据~";
        _iconName = @"logo_Icon";
    
        [self initDefaultUI];
    }
    return self;
}
-(void)initDefaultUI
{
    //图片
    IconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-25,self.frame.size.height/2.0-105, 50, 76)]
    ;
    IconImageView.image = [UIImage imageNamed:_iconName];
    [self addSubview:IconImageView];
    
    //提示语
    tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0-100, IconImageView.frame.origin.y+IconImageView.frame.size.height+10, 200, 30)];
    tipsLabel.text = _tipsString;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor lightGrayColor];
    tipsLabel.font = [UIFont systemFontOfSize:12.5];
    tipsLabel.numberOfLines = 2;
    [self addSubview:tipsLabel];

}

-(void)setIconName:(NSString *)iconName
{
   if(_iconName!=iconName)
   {
       _iconName = iconName;
   }
     IconImageView.image = [UIImage imageNamed:_iconName];
}
-(void)setTipsString:(NSString *)tipsString
{
   if(_tipsString != tipsString)
   {
       _tipsString = tipsString;
   }
    tipsLabel.text = tipsString;
}

@end
