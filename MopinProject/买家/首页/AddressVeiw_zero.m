//
//  AddressVeiw_zero.m
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "AddressVeiw_zero.h"
#import "XHDHelper.h"

@implementation AddressVeiw_zero
{
    UIButton *_showchooseAdressBnt;
    UIButton *_showchooseAdressBnt_1; //图标：收货地址
    UILabel  *_nameLab;
    UILabel  *_telLab;
    UILabel  *_detailLab;
    UIButton *rightArrow;
    
}
- (instancetype)initWithFrame:(CGRect)frame
                   AddressMod:(AddressModel*)mod
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _mod = mod;
        _isShowRightArrow = YES;
        [self _initUI];
    }
    return self;
}

-(void)setMod:(AddressModel *)mod
{
    if(_mod!=mod)
    {
        _mod = mod;
    }
    [self setNeedsLayout];

}
-(void)setIsShowRightArrow:(BOOL)isShowRightArrow
{
    _isShowRightArrow = isShowRightArrow;
    rightArrow.hidden = !_isShowRightArrow;

}

- (void)_initUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:mRect(0, self.height-5, self.width, 5)];
    bgView.image = mImageByName(@"email");
    [self addSubview:bgView];
    
    //无
    _showchooseAdressBnt = [XHDHelper createButton:mRect(0, self.height/2.0-20, 180, 40) NomalTitle:@"请添加您的常用地址" SelectedTitle:@"请添加您的常用地址" NomalTitleColor:  TipsFontColor SelectTitleColor:TipsFontColor NomalImage:mImageByName(@"Location_148") SelectedImage:mImageByName(@"Location_148") BoardLineWidth:0 target:self selector:nil];
    _showchooseAdressBnt.titleLabel.font
    = UIFONT(12.5);
    [_showchooseAdressBnt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_showchooseAdressBnt setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self addSubview:_showchooseAdressBnt];
    
    
    /*有*/
    CGFloat W = [_mod.Name sizeWithAttributes:@{NSFontAttributeName:UIFONT(13.5)}].width;
    W = W>60?W:60;
    
    _nameLab = [XHDHelper createLabelWithFrame:mRect(25, 15,W, 20) andText:_mod.Name.length?_mod.Name:@"用户名" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:_nameLab];
    
    _telLab = [XHDHelper createLabelWithFrame:mRect(_nameLab.right+15, _nameLab.origin.y, 120, 20) andText:_mod.Mobile.length?_mod.Mobile:@"18612345678" andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [self addSubview:_telLab];
    
    
    _showchooseAdressBnt_1 = [XHDHelper createButton:mRect(_nameLab.origin.x-12, _nameLab.bottom, 85, 35) NomalTitle:@"收货地址:" SelectedTitle:@"收货地址:" NomalTitleColor:  TipsFontColor SelectTitleColor:TipsFontColor NomalImage:mImageByName(@"Location_148") SelectedImage:mImageByName(@"Location_148") BoardLineWidth:0 target:self selector:nil];
    _showchooseAdressBnt_1.titleLabel.font
    = UIFONT(13.5);
    [_showchooseAdressBnt_1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_showchooseAdressBnt_1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, -3, 0)];
    [self addSubview:_showchooseAdressBnt_1];

    
    _detailLab = [XHDHelper createLabelWithFrame:mRect(_showchooseAdressBnt_1.right+5, _nameLab.bottom, self.width-120, 40) andText:_mod.Address.length?_mod.Address:@" " andFont:UIFONT(13.5) AndBackGround:[UIColor clearColor] AndTextColor:MainFontColor];
    [_detailLab adjustsFontSizeToFitWidth];
    _detailLab.numberOfLines = 3;
    [self addSubview:_detailLab];
    
    
    //右键
    rightArrow = [XHDHelper getRightArrowButtonWith:mRect(self.width-45, self.height/2.0-8, 10, 16)];
    [self addSubview:rightArrow];
    
    
    if(_mod==nil)
    {
        _showchooseAdressBnt.hidden = NO;
        _detailLab.hidden = YES;
        _telLab.hidden = YES;
        _nameLab.hidden = YES;
        
    }else
    {
        _showchooseAdressBnt.hidden = YES;
        _detailLab.hidden = NO;
        _telLab.hidden = NO;
        _nameLab.hidden = NO;
    }

}
-(void)layoutSubviews
{
    CGFloat W = [_mod.Name sizeWithAttributes:@{NSFontAttributeName:UIFONT(13.5)}].width;
    W = W>60?W:60;
    _nameLab.frame = mRect(25, 15,W, 20);
    
    _telLab.left = _nameLab.right+15;
    
    _showchooseAdressBnt.hidden = _mod?YES:NO;
    _detailLab.hidden = _mod?NO:YES;
    _telLab.hidden = _mod?NO:YES;
    _nameLab.hidden = _mod?NO:YES;
    _showchooseAdressBnt_1.hidden = _mod?NO:YES;
    
    _nameLab.text = _mod.Name;
    _telLab.text = _mod.Mobile;
    _detailLab.text = _mod.Address;
    
}

@end
