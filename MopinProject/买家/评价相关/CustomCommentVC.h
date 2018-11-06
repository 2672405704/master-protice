//
//  CustomCommentVC.h
//  MopinProject
//
//  Created by xhd945 on 15/12/13.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import "BaseSuperViewController.h"

@interface CustomCommentVC : BaseSuperViewController

//ID类型标记  样品ID 0：书家ID 1：样品ID
@property(nonatomic,assign)NSInteger type;

//书家模式：传书家ID
//用户模式获取书家的评价列表：传书家ID   用户模式获取样品的评价列表：传样品ID
@property(nonatomic,strong)NSString *typeID;

- (instancetype)initWithType:(NSInteger)type AndTypeID:(NSString*)typeID;

@end
