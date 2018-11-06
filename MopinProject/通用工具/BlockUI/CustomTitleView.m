//
//  CustomTitleView.m
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "CustomTitleView.h"
#import "XHDHelper.h"

@implementation CustomTitleView

- (instancetype)initWithFrame:(CGRect)frame
                 AndImageName:(NSString*)imageName
                 AndTitleName:(NSString*)titleStr
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageName = imageName;
        _titleStr = titleStr;
        
    }
    return self;
}

-(void)layoutSubviews
{
    //icon
    UIImageView*icon = [XHDHelper createImageViewWithFrame:mRect(self.width/2.0-40, 2.5, 15, 15) AndImageName:_imageName AndCornerRadius:0 andGestureRecognizer:0 AndTarget:self AndAction:nil];
   // icon.backgroundColor  = [UIColor redColor];
    [self addSubview:icon];
    
    //标题
    UILabel * titleLabel = [XHDHelper createLabelWithFrame:mRect(self.width/2.0-20, 2.5, 65, 15) andText:_titleStr andFont:UIFONT_Tilte(15) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:titleLabel];

}

@end
