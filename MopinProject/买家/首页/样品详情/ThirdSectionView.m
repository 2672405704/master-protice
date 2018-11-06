//
//  SalesView.m
//  View
//
//  Created by happyzt on 15/12/10.
//  Copyright © 2015年 happyzt. All rights reserved.
//

#import "ThirdSectionView.h"
#import "CustomTitleView.h"
#import "XHDHelper.h"

@implementation ThirdSectionView
{
    //4>定制返劵内容
    UILabel *ticketLabel;
    UILabel *ticketContentLabel;
    //5>赠作品集内容
    UIView *divLine;
    UILabel *workLabel;
    UILabel *workContentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initDisplayView];
    }
    
    return self;
}


- (void)initDisplayView
{
    CustomTitleView *  logoTitView = [[CustomTitleView alloc]initWithFrame:mRect(self.width/2.0-50, 20, 100,20) AndImageName:@"tag_easyicon" AndTitleName:@"促销活动"];
    [self addSubview:logoTitView];
    
    //3>定制返劵
    ticketLabel = [[UILabel  alloc] initWithFrame:CGRectMake(25, logoTitView.bottom+25, 100, 15)];
    ticketLabel.text = @"定制返劵";
    ticketLabel.font = UIFONT(15);
    [self addSubview:ticketLabel];
    
   ticketContentLabel = [[UILabel  alloc] initWithFrame:CGRectMake(ticketLabel.left, ticketLabel.bottom+5, self.width-50, 20)];
    ticketContentLabel.text = [NSString stringWithFormat:@"成功定制本书家样品，后返回%@元书家劵",_ReturnCoupon.length?_ReturnCoupon:@"0"] ;
    ticketContentLabel.textColor = MainFontColor;
    ticketContentLabel.font = [UIFont systemFontOfSize:13.5];
    [self addSubview:ticketContentLabel];
    
    if(_Promotional.length)
    {
        //5>分割线
       divLine = [[UIView alloc]initWithFrame:mRect(25,ticketContentLabel.bottom+15, self.width-50, 0.5)];
        divLine.backgroundColor = DIVLINECOLOR_1;
        [self addSubview:divLine];
        
        //6>赠作品集
        workLabel = [[UILabel  alloc] initWithFrame:CGRectMake(ticketLabel.left, ticketContentLabel.bottom+30, 100, 15)];
        workLabel.text = @"赠作品集";
        workLabel.font =UIFONT(15);
        [self addSubview:workLabel];
        
        //7>赠作品集内容
        workContentLabel = [[UILabel  alloc] initWithFrame:CGRectMake(ticketLabel.left, workLabel.bottom+5, self.width-60, 30)];
        workContentLabel.text = _Promotional.length?_Promotional:@"";
        workContentLabel.numberOfLines = 3;
        workContentLabel.textColor = [UIColor grayColor];
        workContentLabel.font = UIFONT(13.5);
        [self addSubview:workContentLabel];
        
        self.height = 205;
    
    }else{
    
        self.height = 135;
    }
    
}

-(void)updateUI
{
    ticketContentLabel.text = [NSString stringWithFormat:@"成功定制本书家样品，后返回%@元书家劵",_ReturnCoupon.length?_ReturnCoupon:@"0"] ;
    
    if(workContentLabel)
    {
       workContentLabel.text = _Promotional.length?_Promotional:@"";
    }
    if(_Promotional.length)
    {
        [self addSubview:workContentLabel];

        if(divLine==nil)
        {
            divLine = [[UIView alloc]initWithFrame:mRect(25,ticketContentLabel.bottom+25, self.width-50, 0.5)];
            divLine.backgroundColor = DIVLINECOLOR_1;
            [self addSubview:divLine];
        }
        if(workLabel == nil)
        {
            //6>赠作品集
            workLabel = [[UILabel  alloc] initWithFrame:CGRectMake(ticketLabel.left, ticketContentLabel.bottom+50, 100, 15)];
            workLabel.text = @"赠作品集";
            workLabel.font =UIFONT(15);
            [self addSubview:workLabel];
        }
        if(workContentLabel==nil)
        {
            //7>赠作品集内容
            workContentLabel = [[UILabel  alloc] initWithFrame:CGRectMake(ticketLabel.left, workLabel.bottom+5, self.width-60, 30)];
            workContentLabel.text = _Promotional.length?_Promotional:@"";
            workContentLabel.numberOfLines = 0;
            workContentLabel.textColor = [UIColor grayColor];
            workContentLabel.font = UIFONT(13.5);
            [self addSubview:workContentLabel];
            
        }
        CGFloat contentLabHeight = [XHDHelper heightOfString:_Promotional font:workContentLabel.font maxSize:CGSizeMake(self.width-60, 1000)].height ;
        contentLabHeight = contentLabHeight>30?contentLabHeight:30;
        workContentLabel.height = contentLabHeight+10;
        self.height = 210+contentLabHeight;
        
    }else{
        
        self.height = 145;
    }
}



@end
