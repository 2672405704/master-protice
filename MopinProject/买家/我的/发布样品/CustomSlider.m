//
//  CustomSlider.m
//  MopinProject
//
//  Created by rt008 on 15/11/30.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (	void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(0, 0, kkDeviceWidth-60, 14);
//}
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(0, 0, kkDeviceWidth-60,10);
//}
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, kkDeviceWidth-60, 14);
}
@end
