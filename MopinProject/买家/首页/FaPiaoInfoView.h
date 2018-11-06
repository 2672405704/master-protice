//
//  FaPiaoInfoView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/20.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GotoFillFaPiaoInfoDelegate <NSObject>

-(void)gotoFillFaPiaoInfo;

@end

@interface FaPiaoInfoView : UIView

@property(nonatomic,strong)NSString *faPiaoContent;//发票内容
@property(nonatomic,weak)id<GotoFillFaPiaoInfoDelegate>delegate;

-(void)_initUI;

@end
