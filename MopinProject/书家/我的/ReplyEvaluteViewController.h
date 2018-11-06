//
//  ReplyEvaluteViewController.h
//  MopinProject
//
//  Created by rt008 on 15/12/4.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@class EvaluteListModel;
@interface ReplyEvaluteViewController : BaseSuperViewController
@property (nonatomic,strong) EvaluteListModel *model;
@property (nonatomic,strong) void (^reloadCell)();
@end
