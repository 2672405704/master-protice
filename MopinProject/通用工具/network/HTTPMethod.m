//
//  HTTPMethod.m
//  TalkBar
//
//  Created by aaa on 13-8-31.
//  Copyright (c) 2013年 pengxin. All rights reserved.
//

#import "HTTPMethod.h"
#import "HTTPRequest.h"
#import "AFHTTPRequestOperationManager.h"
#import "Utility.h"
#import "Reachability.h"
#import "MBProgressHUD+Add.h"
@implementation HTTPMethod

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (void)NET_request:(NSUInteger)HTTP_method
             urlStr:(NSString *)urlStr
  ServiceParameters:(NSMutableDictionary *)parametersDic
            success:(void(^)(NSString *reponse))success
            failure:(void(^)(NSError *error))failure
{
    
    int64_t ID = arc4random();
    NSString *keystr = [NSString stringWithFormat:@"%llu",ID];
    
    NSString *method = dicforkey(parametersDic, @"Method");
    NSString *keyDesStr=[Utility encryptStr:method andKey:keystr];
    
    setDickeyobj(parametersDic, keystr, @"UID");
    
    setDickeyobj(parametersDic, keyDesStr, @"Key");
    
    NSError *error = nil;
    
    //    for (NSString *str in parametersDic.allKeys) {
    //        NSString *parValue = dicforkey(parametersDic, str);
    //
    //    }
    
    
    //    [parametersDic enumerateKeysAndObjectsUsingBlock:^(id key,id obj , BOOL *stop){
    //        NSString *parValue = obj;
    //        if (obj) {
    //            [parArr addObject:parValue];
    //        }
    //    }];
    
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:parametersDic options:0 error:&error];
    NSString *tempJsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    NSString *jsonstr=[tempJsonstr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeoutInterval:HTTP_TIME_OUT];
    NSString *methodstr = dicforkey(parametersDic, @"Method");
    NSLog(@"%@;Method==%@;入参:%@",urlStr,methodstr,jsonstr);
    
    [request setHTTPMethod:@"POST"];
    //请求头的设置
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         NSLog(@"%@;Method==%@;返回值:%@",urlStr,methodstr,responseObject);
        
        success(operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        failure(error);
        Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        switch ([r currentReachabilityStatus]) {
            case NotReachable:
                // 没有网络连接
            {
//                [SVProgressHUD showImage:nil status:@"您的网络出问题了，请检查"];
                [MBProgressHUD showError:@"您的网络出问题了，请检查" toView:nil];
                //            return;
            }
                break;
            case ReachableViaWWAN:
                // 使用3G网络
                break;
            case ReachableViaWiFi:
                // 使用WiFi网络
                break;
        }
        
    }];
    [operation start];
    
}

+ (void)NET_REQUEST:(NSString *)cookie
             urlStr:(NSString *)urlStr
  ServiceParameters:(NSMutableDictionary *)parametersDic
            success:(void(^)(NSString *reponse))success
            failure:(void(^)(NSError *error))failure
{
    //    NSDictionary *hederDic = @{@"service":@"getvehiclesbystationid"};
    //    NSDictionary *bodyDic = @{@"pagesize":@"10",@"stationid":@"3",@"page":@"1"};
    //    NSDictionary *paramDic = @{@"body":bodyDic,@"header":hederDic};
    NSError *error = nil;
    NSData *jsondata = [NSJSONSerialization dataWithJSONObject:parametersDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonstr = [[NSString alloc] initWithData:jsondata encoding:NSUTF8StringEncoding];
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setTimeoutInterval:20];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonstr dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error.code != NSURLErrorTimedOut) {
            NSLog(@"error: %@", error);
            failure(error);
        }
        
    }];
    
    [operation start];
    
}
//http上传图片
+ (void)uploadImageWithParameters:(NSDictionary *)params
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                     SuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        FailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    int64_t ID = arc4random();
    NSString *keystr = [NSString stringWithFormat:@"%llu",ID];
    NSString *method = dicforkey(params, @"Method");
    NSString *keyDesStr=[Utility encryptStr:method andKey:keystr];
    [params setValue:keystr forKey:@"UID"];
    [params setValue:keyDesStr forKey:@"Key"];
    
    NSMutableString * string = [[NSMutableString alloc] init];
    for (NSString * str in params.allKeys) {
        [string appendString:[NSString stringWithFormat:@"'%@':'%@',", str, params[str]]];
    }
    
    NSDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:string forKey:@"ua"];
    NSLog(@"////%@////", string);
    
    // 添加信任返回数据类型
    /*
     HTML : text/html
     纯文本格式 : text/plain
     */
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html/plain",@"application/json", @"text/html", @"text/plain",@"text/xml",nil];
    
    // 单项SSL认证设置
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = HTTP_TIME_OUT;
    
    [manager POST:UPLOADURL parameters:jsonDict constructingBodyWithBlock:block success:success failure:fail];
}

#pragma mark -- 上传头像
+ (void)uploadHeadImageWithParameters:(NSDictionary *)params
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                     SuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        FailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))fail{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    int64_t ID = arc4random();
    NSString *keystr = [NSString stringWithFormat:@"%llu",ID];
    NSString *method = dicforkey(params, @"Method");
    NSString *keyDesStr=[Utility encryptStr:method andKey:keystr];
    [params setValue:keystr forKey:@"UID"];
    [params setValue:keyDesStr forKey:@"Key"];
    
    NSMutableString * string = [[NSMutableString alloc] init];
    for (NSString * str in params.allKeys) {
        [string appendString:[NSString stringWithFormat:@"'%@':'%@',", str, params[str]]];
    }
    
    NSDictionary * jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:string forKey:@"ua"];
    NSLog(@"////%@////", string);
    
    // 添加信任返回数据类型
    /*
     HTML : text/html
     纯文本格式 : text/plain
     */
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html/plain",@"application/json", @"text/html", @"text/plain",@"text/xml",nil];
    
    // 单项SSL认证设置
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    // 设置超时时间
    manager.requestSerializer.timeoutInterval = HTTP_TIME_OUT;
    
    [manager POST:UPLOADHEARDERURL parameters:jsonDict constructingBodyWithBlock:block success:success failure:fail];
}



//+ (void)leftCatorys:(void(^)(NSDictionary *dict))success
//            failure:(void(^)(NSError *error))failure;
//{
//    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
//    
//    setDickeyobj(parameterDic, @"1", @"UserID");
//    setDickeyobj(parameterDic, ProductCategory, @"Method");
//    setDickeyobj(parameterDic, infversion, @"Infversion");
//    
//    [HTTPMethod NET_request:HTTPPOST urlStr:WEBURL ServiceParameters:parameterDic success:^(NSString *reponse) {
//        
//        NSData *jsonDate=[reponse dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error = nil;
//        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:&error];
//        NSInteger code = [jsonDict[@"code"] integerValue];
//        if (code == HTTP_SUC) { //登录成功后，将信息缓存到本地
//            
//            success(jsonDict);
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//        failure(error);
//    }];
//}
@end
