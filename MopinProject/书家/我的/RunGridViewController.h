//
//  RunGridViewController.h
//  MopinProject
//
//  Created by rt008 on 15/12/2.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@class PenmanMainInfoModel;
@interface RunGridViewController : BaseSuperViewController
@property (nonatomic,strong) PenmanMainInfoModel *model;
@property (nonatomic,strong) void(^inputRunGrid)();
@end
