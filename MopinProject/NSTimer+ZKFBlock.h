//
//  NSTimer+ZKFBlock.h
//  MopinProject
//
//  Created by rt008 on 16/1/5.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ZKFBlock)
+ (NSTimer *)ZKF_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
