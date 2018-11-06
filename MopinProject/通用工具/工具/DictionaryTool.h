//
//  DictionaryTool.h
//  YKSSDoctor
//
//  Created by rt008 on 15/6/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryTool : NSObject
+ (DictionaryTool *)shareDictionary;

//网络请求结果显示
+ (void)showResult:(NSString *)msg withCode:(NSInteger)code;
//TODO:拨打电话
- (void)makeingACall:(NSString *)tel;
//TODO:获取时间格式
- (NSDateFormatter *)getDateFormatter;
//TODO:判断字符串是否为空
+ (BOOL)isValidateEmpty:(NSString *)empty;
//TODO:判断字符串是否全为整数
+ (BOOL)isValidateNumber:(NSString *)number;
//判断字符串包含中文 英文 数字 下划线
+ (BOOL)isvalidateNickname:(NSString *)nickName;
@end
