//
//  CustomBannerView.h
//  MopinProject
//
//  Created by rt008 on 15/12/1.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomBannerView : UIView
@property (nonatomic,strong) UILabel *countLabel;
- (instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr;
@end
