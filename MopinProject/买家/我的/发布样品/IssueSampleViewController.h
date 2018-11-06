//
//  IssueSampleViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@class PublishSampleModel;
@interface IssueSampleViewController : BaseSuperViewController
@property (nonatomic,assign) NSInteger type; //0:字体和幅式 1.场所和用途
@property (nonatomic,strong) PublishSampleModel *model;
@end
