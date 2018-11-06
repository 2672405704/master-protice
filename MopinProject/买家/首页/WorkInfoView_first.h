//
//  WorkInfoView_first.h
//  MopinProject
//
//  Created by xhd945 on 15/12/17.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderRequestModel;

@interface WorkInfoView_first : UIView

@property(nonatomic,strong)OrderRequestModel *mod;
@property(nonatomic,weak)UIViewController *delegate;

@end
