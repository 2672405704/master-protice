//
//  DocumentPath.h
//  zipTest
//
//  Created by pengxin on 12-10-11.
//  Copyright (c) 2012年 pengxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DocumentPath : NSObject


+(NSString *)gettimeSp:(NSString *)timestr formatdate:(NSString *)formatdate;

+(NSString *)getDocumentsPath;

+(NSString*)getTime:(NSString*)time;
+(NSString *)stringWithUUID ;
//得到当前时间string
+(NSString *)GetCurrenDateByUser:(int)dateType;
//+(NSString*)getTime:(NSString*)time;
+(NSString *)GetCurrenDateBig:(int)dateType;
//星座转换
+(NSString*)starryByDate:(NSString*)dateStr;

+(NSString*)stringByDate:(NSDate*)date;

+(NSDate*)stringTOdate:(NSString*)datestr;

/*
 *@功能    解压Zip文件
 *
 * 入口参数
 *       :_zipFile   ----->Zip文件地址
 *		 :_unzipPath ----->解压后文件夹存放地址
 *
 * 出口参数
 */
+ (BOOL)unzipOpenFile:(NSString *)_zipFile ToPath:(NSString *)_unzipPath;
+(BOOL)isphoneStyle:(NSString*)str;
+ (BOOL)isloginexpire:(NSString *)loginTime;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//时间戳转时间
+ (NSString *)timelentoTime:(NSString *)timelen;

+ (void)delWhiteSpace:(NSString **)str :(NSString *)valuestr;//去掉某个字符串空格换行

+(NSString *)formatTimelenStr:(NSString *)timelen formatdate:(NSString *)formatdate;//将时间戳转换成最近\几天前...

+(NSString *)gettimeSp;//
+ (int)convertToInt:(NSString*)strtemp;
//得到某个时间string
+(NSString *)GetoneDateBig:(int)dateType :(NSDate*)curDate;
@end
