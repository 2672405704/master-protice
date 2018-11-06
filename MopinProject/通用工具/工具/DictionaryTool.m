//
//  DictionaryTool.m
//  YKSSDoctor
//
//  Created by rt008 on 15/6/26.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "DictionaryTool.h"
#import "DocumentPath.h"

@implementation DictionaryTool
{
    NSDateFormatter *_dateFormatter;
}
+ (DictionaryTool *)shareDictionary
{
    static DictionaryTool * tool=nil;
    if (!tool) {
        tool = [[DictionaryTool alloc] init];
    }
    return tool;
}
//网络请求结果显示
+ (void)showResult:(NSString *)msg withCode:(NSInteger)code
{
    //"msg": "0|操作成功"
    
    if (msg.length) {
        NSArray * arr = [msg componentsSeparatedByString:@"|"];
        if (arr.count > 1) {
            if ([arr[0] integerValue] == 0) {
                [SVProgressHUD dismiss];
                NSLog(@"%@", arr[1]);
            } else { //1-显示给用户看
                [SVProgressHUD show];
                if (code == 1000) {
                    [SVProgressHUD showSuccessWithStatus:arr[1]];
                } else {
                    [SVProgressHUD showErrorWithStatus:arr[1]];
                }
            }
        } else {
            NSLog(@"%@", msg);
            [SVProgressHUD dismiss];
        }
    } else {
        NSLog(@"%@", msg);
        [SVProgressHUD dismiss];
    }
    
}

//TODO:拨打电话
- (void)makeingACall:(NSString *)tel
{
    NSString * str= [[NSString alloc] initWithFormat:@"telprompt://%@", tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (NSDateFormatter *)getDateFormatter
{
    if(!_dateFormatter){
        _dateFormatter=[[NSDateFormatter alloc]init];
    }
    return _dateFormatter;
}
+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
+ (BOOL)isValidateNumber:(NSString *)number
{
    NSString *numberCheck = @"^\\d+$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",numberCheck];
    return [numberTest evaluateWithObject:number];
}
+ (BOOL)isValidateEmpty:(NSString *)empty
{
    NSString *emptyCheck = @"^(\\s)*$";
    NSPredicate *emptyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emptyCheck];
    return [emptyTest evaluateWithObject:empty];
}
+ (BOOL)isvalidateNickname:(NSString *)nickName
{
    NSString *nickNameCheck = @"[\u4e00-\u9fa5a-zA-Z0-9_]{4,16}$";
    NSPredicate *nickNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",nickNameCheck];
    return [nickNameTest evaluateWithObject:nickName];
}
@end
