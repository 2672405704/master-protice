//
//  ZhuanBiaoAndWuLiuView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuanBiaoAndWuLiuView : UIView

@property(nonatomic,strong)NSString *wuliuPrice; //物流价格
@property(nonatomic,strong)NSString *zhuanBiaoPrice;//装裱价格

- (void)_initUI;

@end
