//
//  BaseSuperViewController.h
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/7.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHDHelper.h"

@interface BaseSuperViewController : UIViewController {
    int page;//基类页
}
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong,readonly) UIView *keyBordtoolBar;//键盘上的确定按钮

- (void)setNavBackBtnWithType:(NSInteger)type; //设置左边图片
- (void)backBtnClick;  //返回点击
- (void)setRightNavImageIconWithFrame:(CGSize)size andImageStr:(NSString *)image; //导航栏右边按钮图片
- (void)setRightNavTitleStr:(NSString *)string; //设置导航栏右边按钮文字
- (void)rightNavBtnClick;//导航栏右边点击方法
- (void)hideRightBtn;    //隐藏右边按钮
- (void)setNavBackBtnWithTitle:(NSString *)title;//带文字的返回按钮
@end
