//
//  HTTPMethod.h
//  TalkBar
//
//  Created by aaa on 13-8-31.
//  Copyright (c) 2013年 pengxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface HTTPMethod : NSObject


+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

+ (void)NET_request:(NSUInteger)HTTP_method
                urlStr:(NSString *)urlStr
             ServiceParameters:(NSMutableDictionary *)parametersDic
                          success:(void(^)(NSString *reponse))success
                          failure:(void(^)(NSError *error))failure;

+ (void)NET_REQUEST:(NSString *)cookie
             urlStr:(NSString *)urlStr
  ServiceParameters:(NSMutableDictionary *)parametersDic
            success:(void(^)(NSString *reponse))success
            failure:(void(^)(NSError *error))failure;

//http上传图片
+ (void)uploadImageWithParameters:(NSDictionary *)params
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                     SuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        FailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))fail;

#pragma mark -- 上传头像
+ (void)uploadHeadImageWithParameters:(NSDictionary *)params
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                         SuccessBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            FailBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))fail;

//左侧栏分类
//+ (void)leftCatorys:(void(^)(NSDictionary *dict))success
//            failure:(void(^)(NSError *error))failure;

@end
