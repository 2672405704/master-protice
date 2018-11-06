//
//  NSTimer+ZKFBlock.m
//  MopinProject
//
//  Created by rt008 on 16/1/5.
//  Copyright © 2016年 rt008. All rights reserved.
//

#import "NSTimer+ZKFBlock.h"

@implementation NSTimer (ZKFBlock)
+ (NSTimer *)ZKF_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(ZKF_blockInvoke:) userInfo:[block copy] repeats:repeats];
}
+ (void)ZKF_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}
@end
