//
//  RecommendContentViewController.h
//  MopinProject
//
//  Created by rt008 on 15/11/29.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface RecommendContentViewController : BaseSuperViewController
@property (nonatomic,strong) NSArray *RCArr;
@property (nonatomic,strong) void (^GetrecommendContent)(NSArray *contentArr);
@end
