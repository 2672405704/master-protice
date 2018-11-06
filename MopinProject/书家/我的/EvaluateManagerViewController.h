//
//  EvaluateManagerViewController.h
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

typedef enum : NSUInteger {
    EvaluateManagerVCNormal,             //从我的进来
    EvaluatemanagerVCPenmanDetail,       //从书家详情进来
} EvaluateManagerVCType;

@interface EvaluateManagerViewController : BaseSuperViewController
@property (nonatomic,assign) EvaluateManagerVCType type;
@end
