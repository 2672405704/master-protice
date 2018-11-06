//
//  HTTPRequest.m
//  TalkBar
//
//  Created by aaa on 13-8-31.
//  Copyright (c) 2013年 pengxin. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

+(void)setPostValue:(NSMutableDictionary *)params request:(NSMutableURLRequest *) request{
    
    NSMutableString *pstr = [NSMutableString string];
    for(NSString *key in [params allKeys])
        
    {
        NSString *value=[params objectForKey:key];
        [pstr appendFormat:@"%@=%@&",key,value];

    }
    pstr = (NSMutableString *)[pstr stringByReplacingCharactersInRange:NSMakeRange(pstr.length-1, 1) withString:@""];
    NSData  *postData=[pstr dataUsingEncoding: NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    NSLog(@"参数 {%@} ",params);
    
}

+(NSMutableString *)setGetValue:(NSMutableDictionary *)params{
    
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[params allKeys]];
    
    NSMutableString *baseURL = [NSMutableString stringWithFormat:@"%@%@",[params objectForKey:@"WebURL"],(keys.count>1)?@"?":@""];
    
    [keys removeObject:@"WebURL"];
    for (int i=0; i<[keys count]; i++) {
        NSString *key = keys[i];
        NSString *value=[params objectForKey:key];
        if (i!=0) {
            [baseURL appendFormat:@"&%@=%@",key,value];
        }else{
            [baseURL appendFormat:@"%@=%@",key,value];
        }
        
    }
    NSLog(@"参数 {%@} ",params);
    return baseURL;
    
    
}
+ (NSMutableURLRequest *)getRequest :(NSMutableDictionary *) wsParas
{
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] init];
    [HTTPRequest setPostValue:wsParas request:theRequest];
    
    return theRequest;
}

@end
