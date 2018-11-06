//
//  Utility.h
//  destest
//
//  Created by pengxin on 12-10-10.
//  Copyright (c) 2012年 pengxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "NSData+AES.h"
@interface Utility : NSObject
//+ (NSString *) udid;
+ (NSString *) md5:(NSString *)str;
+ (NSString *) doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;
+ (NSString *) encryptStr:(NSString *) str;
+ (NSString *) encryptStr:(NSString *) str andKey:(NSString *)key;
+ (NSString *) decryptStr:(NSString *) str;


+(NSString *)AES128Encrypt:(NSString *)plainText;

#pragma mark Based64
+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;
+(NSString *)AESKey:(NSString *)str;

//手机号正则表达式
+ (BOOL)isValidPhoneNumber:(NSString *)phoneNumber;

//生成UUID
+(NSString *)stringWithUUID ;

@end
