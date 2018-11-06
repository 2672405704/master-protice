//
//  FifthSectionView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "FifthSectionView.h"
#import "CustomTitleView.h"

#pragma mark -- 每一条要约的视图
@implementation YaYueView
{
    //标题
    UILabel *TitleLab;
    //内容
    UILabel *contentLab;
    //箭头
    UIImageView *rightArrowIcon; //右向箭头
}

-(instancetype)initWithFrame:(CGRect)frame
                   AndTitle:(NSString*)titleStr
                  AndContent:(NSString*)contentStr

{
   if(self = [super initWithFrame:frame])
   {
   
       _titleStr = titleStr;
       _ContentStr = contentStr;
       
       [self initUI];
       //分割线
       _divLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
       _divLine.backgroundColor = DIVLINECOLOR_1;
       [self addSubview:_divLine];
       
       _isShowRightIcon = NO;
              
   }
    return self;
 
}
-(void)setIsShowRightIcon:(BOOL)isShowRightIcon
{
    _isShowRightIcon = isShowRightIcon;
    if(_isShowRightIcon)
    {
        rightArrowIcon.hidden  = NO;
        contentLab.right = self.right-40;
    }else{
    
        rightArrowIcon.hidden  = YES;
        contentLab.right = self.right-25;
    }
}
-(void)initUI
{
    //标题
    TitleLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 35)];
    TitleLab.text = _titleStr;
    TitleLab.textColor = MainFontColor;
    TitleLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:TitleLab];
    
    //内容，要弄个自适应高度
    contentLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 35)];
    contentLab.textColor = THEMECOLOR_1;
    contentLab.text = _ContentStr;
    contentLab.textAlignment = NSTextAlignmentRight;
    contentLab.right = self.right -25;
    contentLab.numberOfLines = 0;
    contentLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:contentLab];
    
    //右向箭头
    rightArrowIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 9, 14)];
    rightArrowIcon.image = [UIImage imageNamed:@"chevron_right_red"];
    rightArrowIcon.hidden = YES;
    rightArrowIcon.right = self.right -25;
    [self addSubview:rightArrowIcon];
    
}

- (void)layoutSubviews
{
    TitleLab.text = _titleStr;
    contentLab.text = _ContentStr;

}

-(void)updateYaoYueUI
{
    TitleLab.text = _titleStr;
    contentLab.text = _ContentStr;
    /*只适应高度*/
    CGFloat height = [XHDHelper heightOfString:_ContentStr font:contentLab.font maxSize:CGSizeMake(50, 300)].height>35?[XHDHelper heightOfString:_ContentStr font:contentLab.font maxSize:CGSizeMake(150, 300)].height:35;
    
    self.height = height;
    _divLine.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
     TitleLab.frame = CGRectMake(5, 0, 100, 35);
    contentLab.frame = CGRectMake(0, 0, 150, height);
    contentLab.right = self.right -25;

}

@end

#define YaoYueH 35
#pragma mark -- 第五段的视图
@implementation FifthSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDisplayView];
    }
    return self;
}
- (void)initDisplayView
{
    CustomTitleView *  logoTitView = [[CustomTitleView alloc]initWithFrame:mRect(self.width/2.0-50, 20, 100,20) AndImageName:@"note_text" AndTitleName:@"定制要约"];
    
    [self addSubview:logoTitView];
    
    //创建8条要约
    NSArray *titleArr = @[@"字体",@"幅式",@"尺寸",@"内容",@"题款",@"纸张",@"装裱",@"创造周期"];
    
    NSString *isInscribe = [_ISInscribe isEqualToString:@"1"]?@"可题款":@"不可题款";
    
    NSArray *contentArr = @[_WordType.length?_WordType:@"楷书",_ShowType.length?_ShowType:@"中堂",_Size.length?_Size:@"0*0CM",_WordNum.length?_WordNum:@"0字",isInscribe,_Material.length?_Material:@"生宣",@"标准装裱",_CreateCycle.length?_CreateCycle:@"0天"];
    
    for(NSInteger i=0;i<8;i++)
    {
        YaYueView *View = [[YaYueView alloc]initWithFrame:mRect(25,YaoYueH*i+50, self.width-50, YaoYueH) AndTitle:titleArr[i] AndContent:contentArr[i]];
        View.tag = 130+i;
        if(i==7)
        {
            View.divLine.hidden = YES;
        }
        [self addSubview:View];
    }
}

-(void)UpdateUI
{
    self.height = 68;
    //创建8条要约
    NSString *isInscribe = [_ISInscribe isEqualToString:@"1"]?@"可题款":@"不可题款";
    
    NSArray *contentArr = @[_WordType.length?_WordType:@"楷书",_ShowType.length?_ShowType:@"中堂",_Size.length?_Size:@"0*0CM",_WordNum.length?_WordNum:@"0字",isInscribe,_Material.length?_Material:@"生宣",@"标准装裱",_CreateCycle.length?_CreateCycle:@"0天"];

    for(NSInteger i = 130;i<138;i++)
    {
        YaYueView *view = [self viewWithTag:i];
        view.ContentStr = contentArr[i-130];
        [view setNeedsLayout];
        self.height += view.height;
    }
    
}

@end
