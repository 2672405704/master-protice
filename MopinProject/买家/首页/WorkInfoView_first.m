//
//  WorkInfoView_first.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "WorkInfoView_first.h"
#import "FifthSectionView.h"
#import "UIKit+AFNetworking.h"
#import "OrderRequestModel.h"
#import "CheckCustomRemarkVC.h"

#define YaoYueH 35

@implementation WorkInfoView_first

- (instancetype)initWithFrame:(CGRect)frame
                        Model:(OrderRequestModel*)model
{
    if(self = [super initWithFrame:frame])
    {
        _mod = model;
    }
    return self;
}

- (void)layoutSubviews
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    //图片
    UIImageView *sampleView= [[UIImageView alloc]initWithFrame:mRect(20, 15, self.width-40, 100)];
    sampleView.backgroundColor = RGBA(250, 250, 250, 1);
    [sampleView setImageWithURL:[NSURL URLWithString:_mod.PhotoURL] placeholderImage:mImageByName(PlaceHeaderRectangularImage)];
    sampleView.contentMode = UIViewContentModeScaleAspectFill;
    sampleView.clipsToBounds = YES;
    [self addSubview:sampleView];
    
    
    //创建8条要约
    NSArray *titleArr = @[@"字体",@"幅式",@"尺寸",@"内容",@"题款",@"纸张",@"装裱",@"创造周期"];
    
    /*是否题款*/
    NSString *isInscribe = ([_mod.IsTiKuan isEqualToString:@"0"]||_mod.IsTiKuan.length==0)?@"无":(_mod.TKContent.length?_mod.TKContent:@"无");
    
    /*装裱方式*/
    NSString *zhuangBiaoType;
    if([_mod.ZhBType isEqualToString:@"1"])
    {
       zhuangBiaoType = @"框装";
        
    }else if([_mod.ZhBType isEqualToString:@"2"]){
        
        zhuangBiaoType = @"轴装";
        
    } else if([_mod.ZhBType isEqualToString:@"3"]){
        
        zhuangBiaoType = @"不装裱";
    }else{
    
        zhuangBiaoType= _mod.ZhBType.length?_mod.ZhBType:@"标准装裱";
    
    }
    
    NSArray *contentArr = @[_mod.wordType.length?_mod.wordType:@"楷书",_mod.showType.length?_mod.showType:@"中堂",_mod.size.length?_mod.size:@"0*0CM",_mod.Content.length?_mod.Content:@"0字",isInscribe,_mod.paperType.length?_mod.paperType:@"生宣",zhuangBiaoType,_mod.zouQi.length?[NSString stringWithFormat:@"%@",_mod.zouQi]:@"0天"];
    
       self.height = 130;
    
    for(NSInteger i=0;i<8;i++)
    {
        YaYueView *View_1 = [[YaYueView alloc]initWithFrame:mRect(20,120+YaoYueH*i, self.width-40, YaoYueH) AndTitle:titleArr[i] AndContent:contentArr[i]];
        [self addSubview:View_1];
       View_1.tag = 2100+i;
       if(i==3)
       {
           if(_mod.Content.length>6)
           {
               View_1.ContentStr =  [XHDHelper replaceString:NSMakeRange(3, _mod.Content.length-3) withString:_mod.Content BaseStringMinLentgh:6];
               View_1.isShowRightIcon = YES;
               [View_1 addTarget:self action:@selector(jumpToCheckDetail:) forControlEvents:UIControlEventTouchUpInside];
           }
          
       }
        if(i==4)
        {
            if(_mod.TKContent.length>8)
            {
                View_1.ContentStr =  [XHDHelper replaceString:NSMakeRange(4, _mod.TKContent.length-8) withString:_mod.TKContent BaseStringMinLentgh:8];
                View_1.isShowRightIcon = YES;
                [View_1 addTarget:self action:@selector(jumpToCheckDetail:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
       if(i==7)
       {
           View_1.divLine.hidden = YES;
       }
        
    }
    self.height = self.height +YaoYueH*8;
}
-(void)jumpToCheckDetail:(YaYueView*)sender
{
     if(sender.tag == 2103)
     {
         NSLog(@"内容详情");
         if(self.delegate)
         {
             
             CheckCustomRemarkVC *check = [[CheckCustomRemarkVC  alloc]initWithContent:_mod.Content TitleName:@"内容详情"];
             [self.delegate.navigationController pushViewController:check animated:YES];
             
         }
     
     }
    if(sender.tag == 2104)
    {
        NSLog(@"题款详情");
        if(self.delegate)
        {
            
            CheckCustomRemarkVC *check = [[CheckCustomRemarkVC  alloc]initWithContent:_mod.TKContent TitleName:@"题款详情"];
            [self.delegate.navigationController pushViewController:check animated:YES];
            
        }
        
    }

}



@end
