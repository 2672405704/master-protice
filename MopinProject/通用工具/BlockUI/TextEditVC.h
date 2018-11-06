//
//  TextEditVC.h
//  YKSSDoctor
//
//  Created by 黄彩霞 on 15/7/16.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

/*
    文本编辑界面，返回文本，不调用接口
*/

#import "BaseSuperViewController.h"

@interface TextEditVC : BaseSuperViewController

@property (nonatomic, assign) BOOL isPhoneNumber; //是否输入电话号码

@property (nonatomic, copy) NSString * titleName; //传入界面标题
@property (nonatomic, assign) NSInteger maxCount; //传入最大字数
@property (nonatomic, copy) NSString * text; //传入默认文字

@property (nonatomic, copy) void(^block)(NSString * text); //返回文本

@property (nonatomic, assign) BOOL isCheck;  //是否是查看，是-不允许编辑 否-允许编辑,默认是允许编辑

@end
