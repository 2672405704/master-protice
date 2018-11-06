//
//  NSString+UTF8.h
//  vanVideo
//
//  Created by 赵化 on 13-6-14.
//  Copyright (c) 2013年 赵化. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UTF8)

- (NSString *)URLEncodedString;


- (NSString *)URLDecodedString;

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
@end
