//
//  MyTabBarController.h
//  SJHairDressingProject
//
//  Created by rt008 on 15/9/8.
//  Copyright (c) 2015年 rt008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabBarController : UITabBarController
- (instancetype)initWithType:(NSInteger)type andSelectedIndex:(NSInteger)selectedIndex;
- (void)selectedIndexClick:(NSInteger)index;
@end
