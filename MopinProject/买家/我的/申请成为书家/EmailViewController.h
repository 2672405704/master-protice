//
//  EmailViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@class PenmanMainInfoModel;
@interface EmailViewController : BaseSuperViewController
@property (nonatomic,strong) PenmanMainInfoModel *model;
@property (nonatomic,strong) void(^confirmEmail)(NSString *email);
@end
