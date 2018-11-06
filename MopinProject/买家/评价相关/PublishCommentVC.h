//
//  FirstViewController.h
//  导航控制器
//
//  Created by happyzt on 15-7-25.
//  Copyright (c) 2015年 www.iphonetrain.com无线互联. All rights reserved.
//


/*发表评价*/
#import "BaseSuperViewController.h"

@interface PublishCommentVC : BaseSuperViewController<UITextViewDelegate>

@property(nonatomic,strong)NSString *orderId;//订单ID


- (instancetype)initWithCodeID:(NSString *)codeID;

@end
