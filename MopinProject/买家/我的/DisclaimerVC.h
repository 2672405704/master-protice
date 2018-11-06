//
//  DisclaimerVC.h
//  MixiMixi
//
//  Created by xhd945 on 15/9/10.
//  Copyright (c) 2015年 HuangCaixia. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface DisclaimerVC : BaseSuperViewController

@property(nonatomic,assign)NSInteger type;  //1-免责 2-评分

- (instancetype)initWiteType:(NSInteger)type;

@end
