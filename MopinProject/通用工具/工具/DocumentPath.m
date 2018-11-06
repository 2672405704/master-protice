//
//  DocumentPath.m
//  zipTest
//
//  Created by pengxin on 12-10-11.
//  Copyright (c) 2012年 pengxin. All rights reserved.
//

#import "DocumentPath.h"
@implementation DocumentPath
static NSDateFormatter *dateFormatter = nil;

+(NSString *)gettimeSp:(NSString *)timestr formatdate:(NSString *)formatdate
{
    if(![formatdate length]||![timestr length]) return nil;
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:formatdate];
    NSDate *localeDate = [dateFormatter dateFromString:timestr];
    NSString *timeSp = [NSString stringWithFormat:@"%g", [localeDate timeIntervalSince1970]*1000];
    return timeSp;
}
+ (NSDateFormatter *)getDateFormatter
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}
+ (NSString *)getDocumentsPath{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [arr objectAtIndex:0];
    return documentPath;
}
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//生成oc uuid
+(NSString *)stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}
+(NSDate*)stringTOdate:(NSString*)datestr
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *currentDate = [dateFormatter dateFromString:datestr];
    return currentDate;
}
+(NSString*)stringByDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //用[NSDate date]可以获取系统当前时间
    //    NSDate *date = [curDate dateByAddingTimeInterval:24*60*60];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    return currentDateStr;
}
//得到当前时间string
+(NSString *)GetCurrenDateBig:(int)dateType
{
    //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    switch (dateType) {
        case 0:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case 1:
            [dateFormatter setDateFormat:@"yyyy-MM"];
            break;
        case 2:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 3:
            [dateFormatter setDateFormat:@"MM.dd"];
            break;
            
        default:
            break;
    }
    
    
    //用[NSDate date]可以获取系统当前时间
    NSDate *curDate = [NSDate date];
    //    NSDate *date = [curDate dateByAddingTimeInterval:24*60*60];
    NSString *currentDateStr = [dateFormatter stringFromDate:curDate];
    
    //alloc后对不使用的对象别忘了release
    //    [dateFormatter release];
    
    return currentDateStr;
}
//得到某个时间string
+(NSString *)GetoneDateBig:(int)dateType :(NSDate*)curDate
{
    //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    switch (dateType) {
        case 0:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case 1:
            [dateFormatter setDateFormat:@"yyyy-MM"];
            break;
        case 2:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 3:
            [dateFormatter setDateFormat:@"MM.dd"];
            break;
            
        default:
            break;
    }
    

    //    NSDate *date = [curDate dateByAddingTimeInterval:24*60*60];
    NSString *currentDateStr = [dateFormatter stringFromDate:curDate];

    
    return currentDateStr;
}
+ (NSString *)timelentoTime:(NSString *)timelen
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    long long timeTamp = [timelen longLongValue];
    NSDate *time = [DocumentPath dateWithTimeIntervalInMilliSecondSince1970:timeTamp];
    NSLog(@"%@",time);
    return [dateFormatter stringFromDate:time];
    
}
+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    return ret;
}
//得到当前时间string
+(NSString *)GetCurrenDateByUser:(int)dateType
{
    //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    NSDate *orDate = [NSDate date];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    switch (dateType) {
        case 0:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            orDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
            break;
        case 1:
            [dateFormatter setDateFormat:@"yyyy-MM"];
            break;
        case 2:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 3:
            
            break;
        case 4:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            orDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*13];
            break;
            
        default:
            break;
    }
    
    
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:orDate];
    
    //alloc后对不使用的对象别忘了release
    //    [dateFormatter release];
    
    return currentDateStr;
}

+(NSString*)getTime:(NSString*)time
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    //    [dateF setTimeZone:[NSTimeZone localTimeZone]];
    [dateF setDateFormat:@"YYYY"];
    NSString *nowYear = [dateF stringFromDate:date];
    
    NSString *cacheYear = [time substringToIndex:4];
    
    if ([nowYear isEqualToString:cacheYear]) {
        NSString *AAA = [time substringFromIndex:5];
        NSArray *arr = [AAA componentsSeparatedByString:@":"];
        AAA = [NSString stringWithFormat:@"%@:%@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
        return AAA;
    }else{
        
        NSArray *arr = [time componentsSeparatedByString:@":"];
        time = [NSString stringWithFormat:@"%@:%@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
        return time;
    }
    return @"";
}
//星座转换
+(NSString*)starryByDate:(NSString*)dateStr
{
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setTimeZone:[NSTimeZone localTimeZone]];
    [dateF setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateF dateFromString:dateStr];
    
    NSMutableArray *dateArr = [[NSMutableArray alloc] init];
    [dateArr addObject:@"3-21|4-20|白羊座"];
    [dateArr addObject:@"4-21|5-20|金牛座"];
    [dateArr addObject:@"5-21|6-21|双子座"];
    [dateArr addObject:@"6-22|7-22|巨蟹座"];
    [dateArr addObject:@"7-23|8-22|狮子座"];
    [dateArr addObject:@"8-23|9-22|处女座"];
    [dateArr addObject:@"9-23|10-23|天秤座"];
    [dateArr addObject:@"10-24|11-21|天蝎座"];
    [dateArr addObject:@"11-22|12-21|射手座"];
    [dateArr addObject:@"12-22|1-19|魔羯座"];
    [dateArr addObject:@"1-20|2-18|水瓶座"];
    [dateArr addObject:@"2-19|3-20|双鱼座"];
    
    NSString *str = @"魔羯座";
    
    for (int i=0; i<dateArr.count; i++) {
        NSString *returnStr = [DocumentPath whichStarry:[dateArr objectAtIndex:i] :date];
        if (returnStr.length >0) {
            // 说明 匹配
            str = returnStr;
            break;
        }
    }
    
    //    [dateF setDateFormat:@"YYYY"];
    //    NSString *minYear = [dateF stringFromDate:date];
    //    NSString *maxYear = [dateF stringFromDate:[NSDate date]];
    //    int year = [maxYear intValue]-[minYear intValue];
    
    return [NSString stringWithFormat:@"%@",str];
    
}
+(NSString*)whichStarry:(NSString*)indexStr :(NSDate*)date
{
    
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setTimeZone:[NSTimeZone systemTimeZone]];
    [dateF setDateFormat:@"MM-dd"];
    NSString *cmpDateStr = [dateF stringFromDate:date];
    NSDate *cmpDate = [dateF dateFromString:cmpDateStr];
    
    
    NSArray *arr = [indexStr componentsSeparatedByString:@"|"];
    
    NSString *beginStr = [arr objectAtIndex:0];
    NSDate *beginDate = [dateF dateFromString:beginStr];
    NSString *endStr = [arr objectAtIndex:1];
    NSDate *endDate = [dateF dateFromString:endStr];
    
    if ([cmpDate isEqualToDate:beginDate] || [cmpDate isEqualToDate:endDate] || ([[cmpDate earlierDate:endDate] isEqualToDate:cmpDate]&&[[cmpDate laterDate:beginDate] isEqualToDate:cmpDate])) {
        return [arr objectAtIndex:2];
    }
    return nil;
    
}
+(BOOL)isphoneStyle:(NSString*)str
{
    NSString * regex = @"^(1(([35][0-9])|(47)|[8][01236789]))\\d{8}$";
    NSLog(@"%@",regex);
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPhone = [pred evaluateWithObject:str];
    return isPhone;
}
+ (void)delWhiteSpace:(NSString **)str :(NSString *)valuestr
{
    *str = [valuestr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//+(NSString *)formatTimelenStr:(NSString *)timelen formatdate:(NSString *)formatdate{
//    
//    NSString *ret = @"";
//    NSString *longtime = [DocumentPath gettimeSp:timelen formatdate:formatdate];
//    ret = [NSDate formattedTimeFromTimeInterval:[longtime longLongValue]];
//    return ret;
//}
+ (int)convertToInt:(NSString*)strtemp
{
//    方法1
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
    
//    方法2
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSData* da = [strtemp dataUsingEncoding:enc];
//    return [da length];
}
@end
