//
//  CustomPriceView.h
//  MopinProject
//
//  Created by xhd945 on 15/12/10.
//  Copyright © 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPriceView : UIView

@property(nonatomic)NSString*price;//价格

- (instancetype)initWithFrame:(CGRect)frame WithPrice:(NSString*)priceStr;


@end
