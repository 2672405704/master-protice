//
//  HTTPRequest.h
//  TalkBar
//
//  Created by aaa on 13-8-31.
//  Copyright (c) 2013年 pengxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HTTPRequest : NSObject
+ (NSMutableURLRequest *)getRequest :(NSMutableDictionary *) wsParas;
+(void)setPostValue:(NSMutableDictionary *)params request:(NSMutableURLRequest *) request;
@end
