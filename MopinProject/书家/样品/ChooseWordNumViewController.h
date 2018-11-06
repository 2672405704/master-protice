//
//  ChooseWordNumViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/27.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@class PublishSampleModel;
@interface ChooseWordNumViewController : BaseSuperViewController
@property (nonatomic,strong) void (^chooseWordNum)(NSInteger minWordNum,NSInteger MaxWordNum);
@property (nonatomic,strong) void (^inputText)(NSString *text);
@property (nonatomic,strong) void (^chooseTikuan)(NSInteger slectedIndex);
@property (nonatomic,assign) NSInteger type;//1.选择文字个数 2.输入推荐内容 3.是否题款
@property (nonatomic,strong) PublishSampleModel *publishModel;
@end
