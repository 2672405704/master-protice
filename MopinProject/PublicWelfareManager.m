//
//  PublicWelfareManager.m
//  MopinProject
//
//  Created by xhd945 on 16/2/2.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "PublicWelfareManager.h"

@implementation PublicWelfareManager
{
    //公益开关 1：开启公益功能  2：关闭公益功能
    NSString *_PublicWelfareState;
}

+(instancetype)shareInstance
{
    static PublicWelfareManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PublicWelfareManager alloc]init];
    });
    return manager;
}

#pragma mark -- 从网络获取公益状态
-(void)requestPublicWelfareState
{
    [SVProgressHUD show];
    NSMutableDictionary *parameterDic=[NSMutableDictionary dictionary];
    [parameterDic setValue:@"GetCommonwealState" forKey:@"Method"];
    [parameterDic setValue:Infversion forKey:@"Infversion"];
    
    
    [HTTPMethod NET_request:1 urlStr:HOSTURL ServiceParameters:parameterDic success:^(NSString *reponse) {
        
        [SVProgressHUD dismiss];
        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
        
        NSString * code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        NSString * msg = jsonObject[@"msg"];
        [DictionaryTool showResult:msg withCode:code.integerValue];
        
        if (code.integerValue == 1000) {
            
            _PublicWelfareState = jsonObject[@"data"][0][@"State"];
            
            
        }
    } failure:^(NSError *error){
        
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
        
    }];

}

#pragma mark -- 获取公益开关，默认是2
-(NSString*)getPublicWelfareState;  
{
    return _PublicWelfareState.length?_PublicWelfareState:@"2";

}

@end
