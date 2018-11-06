//
//  NSData+AES.h
//  BrightEaseParty
//
//  Created by ZhangJC on 13-12-5.
//  Copyright (c) 2013年 yangk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSData (AES)


- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;


@end
