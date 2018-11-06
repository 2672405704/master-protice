//
//  MinQianShiView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/11.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinQianShiView : UIView

@property (nonatomic,strong)NSString *Category;//书家类型  (大家--名家--书家)
@property (nonatomic,strong)NSString *isSigned;//是否是签约作家
@property (nonatomic,strong)NSString *Trend;//势：-1:下降  0：不变  1：上升;//势

-(void)initDisPlayView;
@end
