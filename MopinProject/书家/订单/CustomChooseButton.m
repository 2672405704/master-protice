//
//  CustomChooseButton.m
//  MopinProject
//
//  Created by xhd945 on 15/12/30.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CustomChooseButton.h"

#define kkICONNAME_NOMAL  @"arrow_down.png"
#define kkICONNAME_SELECT  @"arrow_up.png"

@interface CustomChooseButton()
{
    UILabel *titleLab ; //标题
    UIImageView *arrowIcon; //箭头图片
}

@end
@implementation CustomChooseButton
-(instancetype)initWithFrame:(CGRect)frame
{
   if(self = [super initWithFrame:frame])
   {
       [self initUI];
   }
    return self;

}
-(void)initUI
{
    /*标题*/
    titleLab =  [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.text = _titleStr;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.backgroundColor = [UIColor clearColor];
    [titleLab adjustsFontSizeToFitWidth];
    [self addSubview:titleLab];
   
    /*箭头*/
    arrowIcon = [[UIImageView alloc]initWithFrame:CGRectMake(titleLab.frame.size.width+5, self.frame.size.height/2.0-6, 15, 12)];
    arrowIcon.image = [UIImage imageNamed:kkICONNAME_NOMAL];
    [self addSubview:arrowIcon];
    
}
-(void)setTitleStr:(NSString *)titleStr
{
   if(titleStr != _titleStr)
   {
       _titleStr = titleStr;
   }
    titleLab.text = _titleStr;
}
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(selected)
    {
        arrowIcon.image = [UIImage imageNamed:kkICONNAME_SELECT];
    
    }else
    {
       arrowIcon.image = [UIImage imageNamed:kkICONNAME_NOMAL];
    }

}

@end
